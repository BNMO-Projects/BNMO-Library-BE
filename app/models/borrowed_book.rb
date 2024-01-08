# frozen_string_literal: true

class BorrowedBook < ApplicationRecord
  validates :borrow_date, presence: { message: "is required" }
  validates :status, inclusion: %w[VALIDATING ACCEPTED BORROWED RETURNED REJECTED]

  belongs_to :book
  belongs_to :cart_item
end
