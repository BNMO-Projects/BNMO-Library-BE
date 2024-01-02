# frozen_string_literal: true

class Cart < ApplicationRecord
  validates :status, presence: { message: "Status is required" }, inclusion: %w[PENDING SUCCESS]

  belongs_to :user
  has_many :cart_items
end
