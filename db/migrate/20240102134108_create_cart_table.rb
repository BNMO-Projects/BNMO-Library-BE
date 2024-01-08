class CreateCartTable < ActiveRecord::Migration[7.1]
  def change
    create_table :carts, id: :uuid do |t|
      t.string :status, null: false, default: "ACTIVE"
      t.timestamps
    end

    create_table :cart_items, id: :uuid do |t|
      t.integer :price
      t.timestamps
    end

    add_reference :carts, :user, foreign_key: true, type: :uuid, null: false, index: true
    add_reference :cart_items, :cart, foreign_key: true, type: :uuid, null: false, index: true
    add_reference :cart_items, :book, foreign_key: true, type: :uuid, null: false, index: true

    add_reference :borrowed_books, :cart_item, foreign_key: true, type: :uuid, null: false
    add_reference :sold_books, :cart_item, foreign_key: true, type: :uuid, null: false

    add_index :borrowed_books, [:book_id, :cart_item_id], unique: true
    add_index :sold_books, [:book_id, :cart_item_id], unique: true
  end
end
