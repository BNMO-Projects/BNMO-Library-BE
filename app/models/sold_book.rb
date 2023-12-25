# frozen_string_literal: true

class SoldBook < ApplicationRecord
  validates :purchase_date, { message: "Purchase date is required" }
  validates :price, presence: { message: "Price is required" }

  belongs_to :book
end
