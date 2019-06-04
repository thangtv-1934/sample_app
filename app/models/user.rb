class User < ApplicationRecord
  before_save {email.downcase!}
  validates :name, presence: true, length: {maximum: Settings.validates.name_max}
  validates :email, presence: true, length: {maximum: Settings.validates.email_max},
    format: {with: Settings.validates.mail_regex}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.validates.password_min}
  has_secure_password
end
