# frozen_string_literal: true

class CartItemDestroyService < BaseServiceObject
  def initialize(cart_item_id)
    super()
    @cart_item_id = cart_item_id
  end

  def call
    item = CartItem.find_by!(id: @cart_item_id)
    book = Book.find_by_id(item.book_id)
    book.current_stock += 1
    book.save

    item.destroy

    self.result = { message: "Book removed from cart" }
    self
  end
end
