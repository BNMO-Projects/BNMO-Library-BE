class FixUniqueIndexMasterData < ActiveRecord::Migration[7.1]
  def up
    remove_index :book_author, :name
    remove_index :book_category, :name
    remove_index :book_genre, :name
    remove_index :language, :name

    execute "CREATE UNIQUE INDEX index_author_name_unique_lowercase ON book_author USING btree (lower(name));"
    execute "CREATE UNIQUE INDEX index_category_name_unique_lowercase ON book_category USING btree (lower(name));"
    execute "CREATE UNIQUE INDEX index_genre_name_unique_lowercase ON book_genre USING btree (lower(name));"
    execute "CREATE UNIQUE INDEX index_language_name_unique_lowercase ON language USING btree (lower(name));"
  end

  def down
    execute "DROP INDEX index_author_name_unique_lowercase;"
    execute "DROP INDEX index_category_name_unique_lowercase;"
    execute "DROP INDEX index_genre_name_unique_lowercase;"
    execute "DROP INDEX index_language_name_unique_lowercase;"

    add_index :book_author, :name, unique: true
    add_index :book_category, :name, unique: true
    add_index :book_genre, :name, unique: true
    add_index :language, :name, unique: true
  end
end
