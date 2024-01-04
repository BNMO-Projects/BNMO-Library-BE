# frozen_string_literal: true

class Api::Cart::CartItemController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found
  before_action :find_or_create_cart, only: [:index, :create]

  def index
    # Fetch the user's active cart (noted by status PENDING) and get all the cart items inside
    items = CartItem.where(cart_id: @cart.id).joins(book: :author).select("cart_items.id, cart_items.price, books.id AS book_id, books.title, books.book_cover, books.book_type, authors.name AS author_name")

    cart = Cart.where(status: "PENDING").select("carts.id").find_by(user_id: @user_id)
    subtotal = CartItem.where(cart_id: cart.id).sum(:price)

    render json: { data: items, subtotal: subtotal }, status: :ok
  end

  def create
    # Fetch the user's active cart (noted by status PENDING)
    # If not found, create a new cart
    # Once cart is made, check the book stock availability
    # If available, create the cart item
    book = Book.find_by_id(create_params[:book_id])

    if book.current_stock.nonzero?
      item = CartItem.create(book_id: create_params[:book_id], cart_id: @cart.id, price: book.price)

      if item.valid?
        render_valid_create("Cart item")
      else
        render json: { message: "Failed to create cart item", error: item.errors }, status: :unprocessable_entity
      end
    else
      render json: { message: "Book is out of stock" }, status: :bad_request
    end
  end

  def destroy
    item = CartItem.find_by!(id: params[:id])
    item.destroy
    render_valid_delete("Cart item")
  end

  private

  def create_params
    params.require(:data).permit(:book_id)
  end

  def find_or_create_cart
    @cart = Cart.where(status: "PENDING").select("carts.id").find_or_create_by(user_id: @user_id)
  end

  def render_record_not_found
    render json: { message: "Cart item not found" }, status: :not_found
  end
end
