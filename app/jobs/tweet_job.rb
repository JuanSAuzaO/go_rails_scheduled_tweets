class TweetJob < ActiveJob::Base
  require 'publish_to_twitter'

  queue_as :default

  def perform (tweet)
    return if tweet.published?

    return if tweet.publish_at > Time.current

    TwitterApi.publish_to_twitter(tweet)
  end
end