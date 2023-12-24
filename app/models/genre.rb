# frozen_string_literal: true

class Genre < ApplicationRecord
  validates :name, presence: { message: "Genre name is required" }, uniqueness: { message: "Genre already exists" }

  has_many :books, dependent: :destroy
end
