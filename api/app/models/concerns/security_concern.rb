module SecurityConcern
  extend ActiveSupport::Concern

  def encrypt(plain)
    Digest::SHA256.hexdigest(plain)
  end

  def hash_match?(plain, hashed)
    encrypt(plain) == hashed
  end
end
