class UpdateMasterDataConstraint < ActiveRecord::Migration[7.1]
  def change
    add_index :book_author, :name, unique: true
    add_index :book_category, :name, unique: true
    add_index :book_genre, :name, unique: true
    add_index :language, :name, unique: true
  end
end
