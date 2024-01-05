# frozen_string_literal: true

class CartIndexService < BaseServiceObject
  def initialize(user_id)
    super()
    @user_id = user_id
  end

  def call
    # Fetch the user's active cart (noted by status PENDING) and get all the cart items inside
    cart = Cart.where(status: "ACTIVE").select("carts.id").find_or_create_by(user_id: @user_id)
    items = CartItem.where(cart_id: cart.id).joins(book: :author).select("cart_items.id, cart_items.price, books.id AS book_id, books.title, books.book_cover, books.book_type, authors.name AS author_name")
    subtotal = CartItem.where(cart_id: cart.id).sum(:price)

    self.result = { data: items, subtotal: subtotal }
    self
  end
end
