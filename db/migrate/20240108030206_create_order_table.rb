class CreateOrderTable < ActiveRecord::Migration[7.1]
  def change
    create_table :orders, id: :uuid do |t|
      t.string :validation_code
      t.string :status, null: false, default: "PENDING"
      t.timestamps
    end

    add_reference :orders, :user, foreign_key: true, type: :uuid, null: false, index: true
    add_reference :cart_items, :order, foreign_key: true, type: :uuid, index: true

    remove_index :cart_items, [:cart_id, :book_id]
    add_index :cart_items, [:cart_id, :book_id, :order_id], unique: true
  end
end
