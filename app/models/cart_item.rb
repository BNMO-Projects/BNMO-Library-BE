# frozen_string_literal: true

class CartItem < ApplicationRecord
  validates :book_id, uniqueness: { scope: :cart_id, message: "is already added to your cart" }

  belongs_to :cart
  belongs_to :book
  belongs_to :order, optional: true

  has_one :borrowed_book
  has_one :sold_book
end
