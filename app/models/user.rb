class User < ApplicationRecord
  has_secure_password
  has_many :registrations
  has_many :exams, through: :registrations
  validates :username,:password,:email, presence: true
  def generate_magic_link_token
    self.magic_link_token = SecureRandom.urlsafe_base64
    save(validate: false)
  end
end
