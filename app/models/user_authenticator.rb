class UserAuthenticator
  def initialize(user)
    @user = user
  end
  def authenticate(unencrypted_password)
    return false unless @user
    if BCrypt::Password.new(@user.password_digest) == unencrypted_password
      true
    else
      false
    end
  end
end

