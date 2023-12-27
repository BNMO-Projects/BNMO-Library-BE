# frozen_string_literal: true

class UserProfile < ApplicationRecord
  validates :first_name, presence: { message: "First name is required" }
  validates :gender, allow_blank: true, inclusion: %w[MALE FEMALE]

  belongs_to :user
  has_one :user_address
end
