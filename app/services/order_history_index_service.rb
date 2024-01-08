# frozen_string_literal: true

class OrderHistoryIndexService < BaseServiceObject
  def initialize(user_id)
    super()
    @user_id = user_id
  end

  def call
    # Fetch the user's active cart (noted by status ACTIVE) and get all the cart items inside
    orders = Order.includes(cart_items: [borrowed_book: { book: :author }, sold_book: { book: :author }]).where(user_id: @user_id).order(:created_at => :desc)

    # Transform the data
    transformed_orders = orders.map do |item|
      transformed_cart_items = item.cart_items.map do |cart_item|
        # Basic cart item data
        cart_item_data = cart_item.as_json(only: [:price])

        # Extract data from borrowed_book or sold_book
        if cart_item.borrowed_book
          book_data = cart_item.borrowed_book.book
          cart_item_data.merge!(
            status: cart_item.borrowed_book.status,
            book_id: book_data.id,
            title: book_data.title,
            book_cover: book_data.book_cover,
            book_type: book_data.book_type,
            author_name: book_data.author.name
          )
        elsif cart_item.sold_book
          book_data = cart_item.sold_book.book
          cart_item_data.merge!(
            status: nil, # No status for sold books
            book_id: book_data.id,
            title: book_data.title,
            book_cover: book_data.book_cover,
            book_type: book_data.book_type,
            author_name: book_data.author.name
          )
        end

        cart_item_data
      end

      # Construct the final order data with transformed cart items
      item.as_json(only: [:id, :validation_code, :status, :created_at]).merge(cart_items: transformed_cart_items)
    end
    self.result = { data: transformed_orders }
    self
  end
end
