# frozen_string_literal: true

class Order < ApplicationRecord
  validates :status, inclusion: %w[PENDING READY COMPLETED]

  belongs_to :user
  has_many :cart_items
end
