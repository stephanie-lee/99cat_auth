require 'Bcrypt'

class User < ActiveRecord::Base
  attr_reader :password
  validates :user_name, :password_digest, :session_token, presence: true

  has_many :cats,
    class_name: "Cat",
    foreign_key: :user_id,
    primary_key: :id

  before_validation :ensure_session_token
  def self.find_by_credentials(user_name, password)
    user = find_by(user_name: user_name)
    if user
      user.is_password?(password) ? user : nil
    end
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64
  end

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64
    self.save!
    self.session_token
  end


end
