class FixUniqueIndexMasterData < ActiveRecord::Migration[7.1]
  def up
    execute "CREATE UNIQUE INDEX index_author_name_unique_lowercase ON authors USING btree (lower(name));"
    execute "CREATE UNIQUE INDEX index_category_name_unique_lowercase ON categories USING btree (lower(name));"
    execute "CREATE UNIQUE INDEX index_genre_name_unique_lowercase ON genres USING btree (lower(name));"
    execute "CREATE UNIQUE INDEX index_language_name_unique_lowercase ON languages USING btree (lower(name));"
  end

  def down
    execute "DROP INDEX index_author_name_unique_lowercase;"
    execute "DROP INDEX index_category_name_unique_lowercase;"
    execute "DROP INDEX index_genre_name_unique_lowercase;"
    execute "DROP INDEX index_language_name_unique_lowercase;"
  end
end
