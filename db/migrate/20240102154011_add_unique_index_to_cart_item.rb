class AddUniqueIndexToCartItem < ActiveRecord::Migration[7.1]
  def change
    add_index :cart_items, [:cart_id, :book_id], unique: true
  end
end
