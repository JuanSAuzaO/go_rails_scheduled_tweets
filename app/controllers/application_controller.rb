class ApplicationController < ActionController::Base
  before_action :set_current_user

  def set_current_user
    if session[:user_id]
      Current.user = User.find(session[:user_id])
    end
  end

  def req_user_logged_in
    if !Current.user
      redirect_to users_sign_in_path, alert: "You must be signed in to perform that operation"
    end
  end
end
