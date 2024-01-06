# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :email, presence: { message: "is required" }, uniqueness: { message: "already exists" }
  validates :username, presence: { message: "is required" }, uniqueness: { message: "already exists" }
  validates :password, presence: { message: "is required" }, length: { minimum: 8 }
  validates :role, inclusion: %w[ADMIN CUSTOMER]

  has_one :user_profile
  has_many :wishlists
  has_one :cart
end
