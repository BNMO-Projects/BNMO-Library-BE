class AddUniqueIndexToWishlist < ActiveRecord::Migration[7.1]
  def change
    add_index :wishlists, [:user_id, :book_id], unique: true
  end
end
