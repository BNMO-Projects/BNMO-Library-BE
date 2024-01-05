# frozen_string_literal: true

class CatalogDetailService < BaseServiceObject
  def initialize(id)
    super()
    @id = id
  end

  def call
    book = Book.joins(:author, :category, :genre, :language).select("books.id, books.title, books.publication_year, books.isbn, books.book_cover, books.cover_file_name, books.original_stock, books.current_stock, books.description, books.book_type, books.price, authors.name AS author_name, categories.name AS category_name, genres.name AS genre_name, languages.name AS language_name").find_by!(id: @id)
    self.result = book

    self
  end
end
