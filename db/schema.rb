# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_01_02_154011) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "authors", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((name)::text)", name: "index_author_name_unique_lowercase", unique: true
  end

  create_table "books", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.date "publication_year", null: false
    t.string "isbn", null: false
    t.string "book_cover", null: false
    t.string "cover_file_name", null: false
    t.integer "original_stock", default: 0, null: false
    t.integer "current_stock", default: 0, null: false
    t.text "description"
    t.string "book_type", null: false
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "author_id", null: false
    t.uuid "category_id", null: false
    t.uuid "genre_id", null: false
    t.uuid "language_id", null: false
    t.index ["author_id"], name: "index_books_on_author_id"
    t.index ["category_id"], name: "index_books_on_category_id"
    t.index ["genre_id"], name: "index_books_on_genre_id"
    t.index ["language_id"], name: "index_books_on_language_id"
  end

  create_table "borrowed_books", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "borrow_date", null: false
    t.datetime "picked_up_date"
    t.datetime "deadline"
    t.datetime "return_date"
    t.string "status", default: "VALIDATING", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "book_id", null: false
    t.index ["book_id"], name: "index_borrowed_books_on_book_id", unique: true
  end

  create_table "cart_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "cart_id", null: false
    t.uuid "book_id", null: false
    t.index ["book_id"], name: "index_cart_items_on_book_id"
    t.index ["cart_id", "book_id"], name: "index_cart_items_on_cart_id_and_book_id", unique: true
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
  end

  create_table "carts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "status", default: "PENDING", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((name)::text)", name: "index_category_name_unique_lowercase", unique: true
  end

  create_table "genres", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((name)::text)", name: "index_genre_name_unique_lowercase", unique: true
  end

  create_table "languages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((name)::text)", name: "index_language_name_unique_lowercase", unique: true
  end

  create_table "sold_books", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "purchase_date", null: false
    t.integer "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "book_id", null: false
    t.index ["book_id"], name: "index_sold_books_on_book_id", unique: true
  end

  create_table "user_addresses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "street"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_profile_id", null: false
    t.index ["user_profile_id"], name: "index_user_addresses_on_user_profile_id", unique: true
  end

  create_table "user_profiles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name"
    t.string "phone_number"
    t.string "gender"
    t.date "date_of_birth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.uuid "language_id"
    t.index ["language_id"], name: "index_user_profiles_on_language_id"
    t.index ["phone_number"], name: "index_user_profiles_on_phone_number", unique: true
    t.index ["user_id"], name: "index_user_profiles_on_user_id", unique: true
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "username", null: false
    t.string "password_digest", null: false
    t.string "role", default: "CUSTOMER", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email", "username"], name: "index_users_on_email_and_username", unique: true
  end

  create_table "wishlists", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "book_id", null: false
    t.uuid "user_id", null: false
    t.index ["book_id"], name: "index_wishlists_on_book_id"
    t.index ["user_id", "book_id"], name: "index_wishlists_on_user_id_and_book_id", unique: true
    t.index ["user_id"], name: "index_wishlists_on_user_id"
  end

  add_foreign_key "books", "authors"
  add_foreign_key "books", "categories"
  add_foreign_key "books", "genres"
  add_foreign_key "books", "languages"
  add_foreign_key "borrowed_books", "books"
  add_foreign_key "cart_items", "books"
  add_foreign_key "cart_items", "carts"
  add_foreign_key "carts", "users"
  add_foreign_key "sold_books", "books"
  add_foreign_key "user_addresses", "user_profiles"
  add_foreign_key "user_profiles", "languages"
  add_foreign_key "user_profiles", "users"
  add_foreign_key "wishlists", "books"
  add_foreign_key "wishlists", "users"
end
