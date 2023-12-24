class AddBookPriceColumn < ActiveRecord::Migration[7.1]
  def change
    add_column :book, :price, :integer
  end
end
