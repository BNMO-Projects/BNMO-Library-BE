# frozen_string_literal: true

class WishlistCreateService < BaseServiceObject
  def initialize(user_id, book_id)
    super()
    @user_id = user_id
    @book_id = book_id
  end

  def call
    wishlist = Wishlist.new(book_id: @book_id, user_id: @user_id)

    if wishlist.valid?
      wishlist.save
      self.result = { wishlist: wishlist }
    else
      self.errors = wishlist.errors.full_messages
    end

    self
  end
end
