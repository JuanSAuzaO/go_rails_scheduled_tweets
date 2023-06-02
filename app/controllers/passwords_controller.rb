class PasswordsController < ApplicationController
  def edit
    @user = User.find_by(id: Current.user.id)
  end

  def update
    @user = User.find_by(id: Current.user.id)
    if @user.update(password_params)
      flash[:notice] = "Password change succesfully"
      redirect_to root_path
    else
      flash.now[:alert] = "Couldn't change your password"
      render :edit
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end