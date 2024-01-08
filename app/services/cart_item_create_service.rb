# frozen_string_literal: true

class CartItemCreateService < BaseServiceObject
  def initialize(user_id, book_id)
    super()
    @user_id = user_id
    @book_id = book_id
  end

  def call
    # Fetch the user's active cart (noted by status ACTIVE)
    # If not found, create a new cart
    # Once cart is made, check the book stock availability
    # If available, create the cart item
    cart = Cart.where(status: "ACTIVE").select("carts.id").find_or_create_by!(user_id: @user_id)
    book = Book.find_by_id!(@book_id)

    if book.current_stock.nonzero?
      item = CartItem.new(book_id: @book_id, cart_id: cart.id, price: book.price)

      if item.valid?
        book.decrement(:current_stock)
        book.save
        item.save
        self.result = { item: item }
      else
        self.errors = item.errors.full_messages
      end
    else
      self.errors = ["Book is out of stock"]
    end

    self
  end
end
