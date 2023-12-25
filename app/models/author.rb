# frozen_string_literal: true

class Author < ApplicationRecord
  validates :name, presence: { message: "Author name is required" }, uniqueness: { message: "Author already exists" }

  has_many :books, dependent: :destroy
end
