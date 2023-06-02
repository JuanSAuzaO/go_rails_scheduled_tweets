class TwitterAccountsController < ApplicationController
  before_action :req_user_logged_in
  before_action :set_twitter_account, only: [:destroy]

  def index
    @twitter_accounts = Current.user.twitter_accounts
  end

  def destroy
    
    @twitter_account.delete
    redirect_to root_path, notice: "Account succesfully disconnected"
  end

  private

  def set_twitter_account
    @twitter_account = Current.user.twitter_accounts.find(params[:id])
  end
end