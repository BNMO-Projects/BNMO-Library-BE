# frozen_string_literal: true

class Category < ApplicationRecord
  validates :name, presence: { message: "Category name is required" }, uniqueness: { message: "Category already exists" }

  has_many :books, dependent: :destroy
end
