class User < ApplicationRecord
  devise :database_authenticatable,
    :registerable,
    :jwt_authenticatable,
    jwt_revocation_strategy: JWTBlacklist
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: true
end
