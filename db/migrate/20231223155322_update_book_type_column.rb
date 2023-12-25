class UpdateBookTypeColumn < ActiveRecord::Migration[7.1]
  def change
    rename_column :book, :type, :book_type
  end
end
