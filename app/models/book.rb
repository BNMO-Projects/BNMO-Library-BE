# frozen_string_literal: true

class Book < ApplicationRecord
  validates :title, presence: { message: "Title is required" }
  validates :publication_year, presence: { message: "Publication year is required" }
  validates :isbn, presence: { message: "ISBN is required" }, uniqueness: { message: "ISBN already exists" }
  validates :book_cover, presence: { message: "Book cover is required" }
  validates :cover_file_name, presence: { message: "Cover file name is required" }
  validates :book_type, presence: { message: "Type is required" }, inclusion: %w[BORROWABLE ONSALE]
  validates :author_id, presence: { message: "Author ID is required" }
  validates :category_id, presence: { message: "Category ID is required" }
  validates :genre_id, presence: { message: "Genre ID is required" }
  validates :language_id, presence: { message: "Language ID is required" }

  belongs_to :author
  belongs_to :category
  belongs_to :genre
  belongs_to :language

  has_many :borrowed_books
  has_many :sold_books

  has_many :wishlists
  has_many :cart_items
end
