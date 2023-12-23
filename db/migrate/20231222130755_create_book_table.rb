class CreateBookTable < ActiveRecord::Migration[7.1]
  def change
    create_table :book, id: :uuid do |t|
      t.string :title, null: false
      t.date :publication_year, null: false
      t.string :isbn, null: false
      t.string :book_cover, null: false
      t.string :cover_file_name, null: false
      t.integer :original_stock, null: false, default: 0
      t.integer :current_stock, null: false, default: 0
      t.text :description
      t.string :type, null: false
      t.column :author_id, :uuid
      t.column :category_id, :uuid
      t.column :genre_id, :uuid
      t.column :language_id, :uuid
      t.timestamps
    end

    add_foreign_key :book, :book_author, column: :author_id
    add_foreign_key :book, :book_category, column: :category_id
    add_foreign_key :book, :book_genre, column: :genre_id
    add_foreign_key :book, :language, column: :language_id
  end
end
