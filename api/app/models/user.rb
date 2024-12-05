class User < ApplicationRecord
  include SecurityConcern

  attr_accessor :password

  validates :name, presence: true
  validates :email, presence: true

  has_secure_token :token_digest, length: 36
  has_one :user_wallet

  before_save :encrypt_password

  def encrypt_password
    self.password_digest = encrypt(password) unless password.blank?
  end

  def authenticate(password)
    if hash_match?(password, password_digest)
      regenerate_token_digest
      return true
    end
    false
  end

  def access_token
    "#{id}|#{encrypt(token_digest)}"
  end

  def to_json
    { id: id, name: name, email: email, created_at: created_at }
  end
end
