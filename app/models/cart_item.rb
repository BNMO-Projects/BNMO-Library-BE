# frozen_string_literal: true

class CartItem < ApplicationRecord
  validates :book_id, uniqueness: { scope: :cart_id, message: "is already added to your cart" }

  belongs_to :cart
  belongs_to :book
  belongs_to :order
end
