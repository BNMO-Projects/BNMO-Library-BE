class CreateWishlistTable < ActiveRecord::Migration[7.1]
  def change
    create_table :wishlists, id: :uuid do |t|
      t.timestamps
    end

    add_reference :wishlists, :book, foreign_key: true, type: :uuid, null: false, index: true
    add_reference :wishlists, :user, foreign_key: true, type: :uuid, null: false, index: true
  end
end
