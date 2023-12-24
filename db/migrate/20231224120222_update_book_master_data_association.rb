class UpdateBookMasterDataAssociation < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :book, column: :author_id
    remove_foreign_key :book, column: :category_id
    remove_foreign_key :book, column: :genre_id
    remove_foreign_key :book, column: :language_id

    rename_table :book_author, :authors
    rename_table :book_category, :categories
    rename_table :book_genre, :genres
    rename_table :language, :languages

    remove_column :book, :author_id
    remove_column :book, :category_id
    remove_column :book, :genre_id
    remove_column :book, :language_id

    add_reference :book, :author, foreign_key: true, type: :uuid
    add_reference :book, :category, foreign_key: true, type: :uuid
    add_reference :book, :genre, foreign_key: true, type: :uuid
    add_reference :book, :language, foreign_key: true, type: :uuid
  end
end
