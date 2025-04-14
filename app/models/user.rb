class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true

  def generate_api_token
    loop do
      self.api_token = SecureRandom.hex(32)
      break unless User.exists?(api_token: api_token)
    end
    save!
  end

  def reset_api_token
    self.api_token = nil
    save!
  end
end
