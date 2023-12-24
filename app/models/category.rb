# frozen_string_literal: true

class Category < ApplicationRecord
  self.table_name = "book_category"

  validates :name, presence: { message: "Category name is required" }, uniqueness: { message: "Category already exists" }
end
