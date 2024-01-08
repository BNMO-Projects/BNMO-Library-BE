# frozen_string_literal: true

class SoldBook < ApplicationRecord
  validates :purchase_date, presence: { message: "Purchase date is required" }
  validates :price, presence: { message: "Price is required" }

  belongs_to :book
  belongs_to :cart_item
end
