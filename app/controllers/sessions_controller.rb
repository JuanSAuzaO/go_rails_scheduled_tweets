class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user.present? && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "User signed in succesfully"
      redirect_to root_path
    else
      flash.now[:alert] = "Invalid credentials"
      @user = nil
      render :new
    end
  end

  def destroy
    @user = User.find_by(id: session[:user_id])
    if @user.present?
      session[:user_id] = nil
      flash[:notice] = "User signed out succesfully"
      redirect_to root_path
    end
  end
end