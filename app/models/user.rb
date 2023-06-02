class User < ApplicationRecord
  has_many :twitter_accounts
  has_many :tweets
  has_secure_password
  
  validates :name, presence: true, length: { minimum: 2, maximum: 64}
  validates :email, presence:true, uniqueness: true
  validate :is_email?
  validates :password, presence: true, length: { minimum: 8, maximum: 64 }
  validates :password_confirmation, presence:true, length: { minimum: 8, maximum: 64 }

  private

  def is_email?
    unless email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      errors.add(:email, "is not valid")
    end
  end

end