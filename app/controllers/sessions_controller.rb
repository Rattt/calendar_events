class SessionsController < ApplicationController

  def new
    @user = User.new
    if signed_in?
      redirect_to edit_user_path(current_user)
    end
  end

  def create
    user_data = session_params
    user = User.find_by(email: user_data[:email])
    if UserAuthenticator.new(user).authenticate(user_data[:password])
      sign_in(user)
      redirect_to edit_user_path(user)
    else
      redirect_to new_session_path, notice: I18n.t('notice.incorrect_password')
    end
  end

  def destroy
    sign_out
    redirect_to root_path, notice: I18n.t('notice.session_completed')
  end


  private

  def session_params
    params.require(:user).permit(:email, :password)
  end

end