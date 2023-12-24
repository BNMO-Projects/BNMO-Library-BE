# frozen_string_literal: true

class Genre < ApplicationRecord
  self.table_name = "book_genre"

  validates :name, presence: { message: "Genre name is required" }, uniqueness: { message: "Genre already exists" }
end
