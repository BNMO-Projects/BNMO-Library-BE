# frozen_string_literal: true

class CartCheckoutService < BaseServiceObject
  def initialize(user_id)
    super()
    @user_id = user_id
  end

  def call
    Cart.transaction do
      cart = Cart.where(status: "ACTIVE").select("carts.id, carts.user_id").find_by!(user_id: @user_id)
      items = CartItem.where(cart_id: cart.id).joins(:book)
      order = Order.create!(user_id: @user_id)

      items.each do |item|
        item.update!(order_id: order.id)
        process_book(item)
      end

      cart.update!(status: "COMPLETED")
      self.result = { cart: cart }
    end
  rescue ActiveRecord::RecordNotFound => e
    self.errors = [e.message]
    raise ActiveRecord::Rollback
  rescue StandardError => e
    self.errors = [e]
    raise ActiveRecord::Rollback
  ensure
    return self
  end

  private

  def process_book(item)
    if item.book.book_type === "BORROWABLE"
      BorrowedBook.create!(borrow_date: Time.now, book_id: item.book.id, cart_item_id: item.id)
    elsif item.book.book_type === "ONSALE"
      SoldBook.create!(purchase_date: Time.now, price: item.price, book_id: item.book.id, cart_item_id: item.id)
    end
  end
end
