# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :email, presence: { message: "Email is required" }, uniqueness: { message: "Email already exists" }
  validates :username, presence: { message: "Username is required" }, uniqueness: { message: "Username already exists" }
  validates :password, presence: { message: "Password is required" }, length: { minimum: 8 }
  validates :role, inclusion: %w[ADMIN CUSTOMER]

  has_one :user_profile
  has_many :wishlists
  has_one :cart
end
