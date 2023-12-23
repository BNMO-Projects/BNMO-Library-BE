class CreateSoldBookTable < ActiveRecord::Migration[7.1]
  def change
    create_table :sold_book, id: :uuid do |t|
      t.datetime :purchase_date, null: false
      t.integer :price, null: false
      t.column :book_id, :uuid
      t.timestamps
    end

    add_foreign_key :sold_book, :book, column: :book_id
    add_index :sold_book, :book_id, unique: true
  end
end
