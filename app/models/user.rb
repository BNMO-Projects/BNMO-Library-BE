class User < ApplicationRecord
  self.table_name = "user"
  has_secure_password

  validates :email, presence: { message: "Email is required" }, uniqueness: { message: "Email already exists" }
  validates :username, presence: { message: "Username is required" }, uniqueness: { message: "Username already exists" }
  validates :password, presence: { message: "Password is required" }, length: { minimum: 8 }
end
