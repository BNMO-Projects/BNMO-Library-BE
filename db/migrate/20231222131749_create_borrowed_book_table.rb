class CreateBorrowedBookTable < ActiveRecord::Migration[7.1]
  def change
    create_table :borrowed_books, id: :uuid do |t|
      t.datetime :borrow_date, null: false
      t.datetime :picked_up_date
      t.datetime :deadline
      t.datetime :return_date
      t.string :status, null: false, default: 'VALIDATING'
      t.timestamps
    end

    add_reference :borrowed_books, :book, foreign_key: true, type: :uuid, null: false, index: { unique: true }
  end
end
