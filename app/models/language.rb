# frozen_string_literal: true

class Language < ApplicationRecord
  validates :name, presence: { message: "Language name is required" }, uniqueness: { message: "Language already exists" }

  has_many :books, dependent: :destroy
end
