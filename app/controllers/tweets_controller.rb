class TweetsController < ApplicationController
  require 'publish_to_twitter'
  before_action :req_user_logged_in
  before_action :set_tweet, only: [:edit, :update, :destroy, :publish_to_twitter]

  def index
    @tweets = Current.user.tweets
  end

  def new
    @tweet = Tweet.new
  end

  def create
    @tweet = Current.user.tweets.new(twitter_params)
    if @tweet.save
      flash[:notice] = "Tweet succesfully scheduled!"
      redirect_to tweets_path
    else
      flash.now[:alert] = "Tweet couldn't be scheduled!"
      render :new
    end
  end

  def edit
  end

  def update
    if @tweet.update(twitter_params)
      redirect_to tweets_path, notice: "Scheduled Tweet succesfully edited!"
    else
      flash.now[:alert] = "Tweet couldn't be edited!"
      render :edit
    end
  end

  def destroy
    @tweet.destroy
    redirect_to tweets_path, notice: "Tweet was succesfully unscheduled!"
  end

  def publish_to_twitter
    
    response = TwitterApi.publish_to_twitter(@tweet)

    if response.code == 201
      redirect_to tweets_path, notice: "Tweet succesfully posted!"
    else
      flash.now[:alert] = "Tweet couldn't be posted!"
      redirect_to tweets_path, alert: "Tweet couldn't be posted!"
    end

  end

  private

  def twitter_params
    params.require(:tweet).permit(:twitter_account_id, :body, :publish_at)
  end

  def set_tweet
    @tweet = Current.user.tweets.find(params[:id])
  end
end