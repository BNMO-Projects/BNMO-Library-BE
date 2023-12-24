# frozen_string_literal: true

class Author < ApplicationRecord
  self.table_name = "book_author"

  validates :name, presence: { message: "Author name is required" }, uniqueness: { message: "Author already exists" }
end
