# frozen_string_literal: true

class Wishlist < ApplicationRecord
  belongs_to :user
  belongs_to :book
end
