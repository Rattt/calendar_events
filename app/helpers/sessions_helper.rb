module SessionsHelper

  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    @current_user = user
  end

  def sign_out
    current_user.update_attribute(:remember_token, User.encrypt(User.new_remember_token)) if signed_in?
    cookies.delete(:remember_token)
    @current_user = nil
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == @current_user
  end

  def signed_in?
    !current_user.nil?
  end

  def private_access!
    unless signed_in?
      render :text => "Access denied 403", :status => 403, :layout => false
    end
  end

end