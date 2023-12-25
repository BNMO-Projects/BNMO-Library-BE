# frozen_string_literal: true

class UserProfile < ApplicationRecord
  validates :first_name, presence: { message: "First name is required" }

  belongs_to :user
  has_one :user_address
end
