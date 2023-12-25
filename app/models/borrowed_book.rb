# frozen_string_literal: true

class BorrowedBook < ApplicationRecord
  validates :borrow_date, presence: { message: "Borrow date is required" }
  validates :status, presence: { message: "Status is required" }, inclusion: %w[VALIDATING ACCEPTED BORROWED RETURNED REJECTED]

  belongs_to :book
end
