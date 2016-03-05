class User < ActiveRecord::Base

  has_many :events

  before_validation :downcase_full_name!
  before_validation :downcase_email!
  before_create :create_remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true, length: { maximum: 120 }
  validates :password, presence: true, length: { minimum: 8 }

  private

  def downcase_full_name!
    self.full_name.downcase! if full_name.present?
  end

  def downcase_email!
    self.email.downcase! if email.present?
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end
  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end

  has_secure_password
end
