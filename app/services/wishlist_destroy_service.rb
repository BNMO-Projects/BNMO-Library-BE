# frozen_string_literal: true

class WishlistDestroyService < BaseServiceObject
  def initialize(wishlist_id)
    super()
    @wishlist_id = wishlist_id
  end

  def call
    item = Wishlist.find_by_id!(@wishlist_id)
    item.destroy

    self.result = { message: "Book removed from wishlist" }
    self
  end
end
