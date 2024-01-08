# frozen_string_literal: true

class Cart < ApplicationRecord
  validates :status, inclusion: %w[ACTIVE COMPLETED]

  belongs_to :user
  has_many :cart_items
end
