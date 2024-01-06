# frozen_string_literal: true

class CatalogDetailService < BaseServiceObject
  def initialize(book_id, user_id)
    super()
    @book_id = book_id
    @user_id = user_id
  end

  def call
    book = Book.joins(:author, :category, :genre, :language).select("books.id, books.title, books.publication_year, books.isbn, books.book_cover, books.cover_file_name, books.original_stock, books.current_stock, books.description, books.book_type, books.price, authors.name AS author_name, categories.name AS category_name, genres.name AS genre_name, languages.name AS language_name").find_by!(id: @book_id)
    in_wishlist = Wishlist.find_by(book_id: @book_id, user_id: @user_id)
    in_cart = CartItem.joins(:cart).find_by(book_id: @book_id, carts: { user_id: @user_id, status: 'ACTIVE' })

    details = book.attributes
    details[:in_wishlist] = in_wishlist.present?
    details[:wishlist_id] = in_wishlist.id if in_wishlist.present?
    details[:in_cart] = in_cart.present?
    details[:cart_item_id] = in_cart.id if in_cart.present?

    self.result = details

    self
  end
end
