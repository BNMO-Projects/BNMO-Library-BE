class CreateBorrowedBookTable < ActiveRecord::Migration[7.1]
  def change
    create_table :borrowed_book, id: :uuid do |t|
      t.datetime :borrow_date, null: false
      t.datetime :picked_up_date
      t.datetime :deadline
      t.datetime :return_date
      t.string :status, null: false, default: 'VALIDATING'
      t.column :book_id, :uuid
      t.timestamps
    end

    add_foreign_key :borrowed_book, :book, column: :book_id
    add_index :borrowed_book, :book_id, unique: true
  end
end
