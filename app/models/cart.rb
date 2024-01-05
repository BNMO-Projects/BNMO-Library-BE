# frozen_string_literal: true

class Cart < ApplicationRecord
  validates :status, presence: { message: "is required" }, inclusion: %w[ACTIVE COMPLETED]

  belongs_to :user
  has_many :cart_items
end
