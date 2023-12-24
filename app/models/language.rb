# frozen_string_literal: true

class Language < ApplicationRecord
  self.table_name = "language"

  validates :name, presence: { message: "Language name is required" }, uniqueness: { message: "Language already exists" }
end
