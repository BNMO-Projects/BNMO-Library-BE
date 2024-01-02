class CreateCartTable < ActiveRecord::Migration[7.1]
  def change
    create_table :carts, id: :uuid do |t|
      t.string :status, null: false, default: "PENDING"
      t.timestamps
    end

    create_table :cart_items, id: :uuid do |t|
      t.integer :price
      t.timestamps
    end

    add_reference :carts, :user, foreign_key: true, type: :uuid, null: false, index: true
    add_reference :cart_items, :cart, foreign_key: true, type: :uuid, null: false, index: true
    add_reference :cart_items, :book, foreign_key: true, type: :uuid, null: false, index: true
  end
end
