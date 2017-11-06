class User < ApplicationRecord
  has_secure_password
  validates :password, length: { minimum: 8 }
end
