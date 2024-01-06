# frozen_string_literal: true

class Wishlist < ApplicationRecord
  validates :book_id, uniqueness: { scope: :user_id, message: "is already in your wishlist" }

  belongs_to :user
  belongs_to :book
end
