module TwitterApi
  require 'oauth'
  require 'json'
  require 'typhoeus'
  require 'oauth/request_proxy/typhoeus_request'

  def self.get_request_token(consumer)

    request_token = consumer.get_request_token()

    return request_token
  end

  def self.get_user_authorization(request_token)
    puts "Follow this URL to have a user authorize your app: #{request_token.authorize_url()}"
    puts "ENTER PIN: "

    pin = gets.strip

    return pin
  end

  def self.obtain_access_token(consumer, request_token, pin)
    token = request_token.token
    secret = request_token.secret
    hash = { :oauth_token => token, :oauth_token_secret => secret }
    request_token = OAuth::RequestToken.from_hash(consumer, hash)

    access_token = request_token.get_access_token(:oauth_verifier => pin)

    return access_token
  end

  def self.create_tweet(url, oauth_params)
    options = {
      :method => :post,
      headers: {
        "User-Agent": "v2CreateTweetRuby",
        "content-type": "application/json"
        },
        body: JSON.dump(@json_payload)
      }
      request = Typhoeus::Request.new(url, options)
      oauth_helper = OAuth::Client::Helper.new(request, oauth_params.merge(:request_uri => url))
      request.options[:headers].merge!({"Authorization" => oauth_helper.header })
      response = request.run

      return response
  end

  def self.publish_to_twitter(tweet)

    consumer_key = Rails.application.credentials.dig(:twitter, :api_key)
    consumer_secret = Rails.application.credentials.dig(:twitter, :api_secret_key)

    create_tweet_url = "https://api.twitter.com/2/tweets"

    @json_payload = { "text": tweet.body }

    consumer = OAuth::Consumer.new(consumer_key, consumer_secret,
                                    :site => 'https://api.twitter.com',
                                    :authorize_path => '/oauth/authenticate',
                                    :debug_output => false )
                                    
    serialized_data = tweet.twitter_account.access_token

    if serialized_data == "" || serialized_data == nil

      request_token = self.get_request_token(consumer)

      pin = self.get_user_authorization(request_token)

      access_token = self.obtain_access_token(consumer, request_token, pin)

      serialized_data = Marshal.dump(access_token)

      tweet.twitter_account.update(access_token: serialized_data)

    end

    access_token = Marshal.load(serialized_data)

    oauth_params = { :consumer => consumer, :token => access_token }

    response = self.create_tweet(create_tweet_url, oauth_params)

    response_hash = JSON.parse(response.body)

    if response.code == 201
      tweet.update(tweet_id: response_hash["data"]["id"])
    end
    
    return response
  end

end