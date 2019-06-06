class User < ApplicationRecord
  attr_accessor :remember_token

  before_save {email.downcase!}
  validates :name, presence: true, length: {maximum: Settings.validates.name_max}
  validates :email, presence: true, length: {maximum: Settings.validates.email_max},
    format: {with: Settings.validates.mail_regex}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.validates.password_min}, allow_nil: true

  has_secure_password

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update remember_digest: nil
  end

  def current_user? user
    self == user
  end
end
