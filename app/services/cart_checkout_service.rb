# frozen_string_literal: true

class CartCheckoutService < BaseServiceObject
  def initialize(user_id)
    super()
    @user_id = user_id
  end

  def call
    # TODO: Do checkout process as this is just a placeholder
    cart = Cart.where(status: "ACTIVE").select("carts.id").find_or_create_by(user_id: @user_id)
    subtotal = CartItem.where(cart_id: cart.id).sum(:price)
    self.result = { subtotal: subtotal }
    self
  end
end
