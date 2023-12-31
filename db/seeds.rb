# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Generate 20 author
(1..20).each do
  Author.create!(name: Faker::Book.unique.author)
end

categories = ["Novel", "Manga", "Magazine", "Comic Book", "Text Book", "Graphic Novel", "Light Novel"]
# Generate 10 categories
categories.each do |category|
  Category.create!(name: category)
end

# Generate 10 genres
(1..10).each do
  Genre.create!(name: Faker::Book.unique.genre)
end

# Generate 10 languages
(1..10).each do
  Language.create!(name: Faker::Nation.unique.language)
end

# Generate 200 books
types = %w[BORROWABLE ONSALE]
(1..200).each do
  book_type = types.sample
  original_stock = Faker::Number.within(range: 1..100)
  price = nil
  if book_type === "ONSALE"
    price = Faker::Number.within(range: 10000..500000)
  end
  Book.create!(
    title: Faker::Book.title,
    publication_year: Faker::Date.between(from: 2.years.ago.to_date, to: Date.today),
    isbn: Faker::Code.unique.isbn(base: 13),
    book_cover: "https://firebasestorage.googleapis.com/v0/b/bnmo-projects.appspot.com/o/book-cover%2F215583a4-71ab-484c-b4c5-547b1ab2c2e8-potter%203.jpg?alt=media&token=4593e864-05cb-47b6-863f-1baf7a51b1d1",
    cover_file_name: "book-cover/215583a4-71ab-484c-b4c5-547b1ab2c2e8-potter 3.jpg",
    original_stock: original_stock,
    current_stock: Faker::Number.within(range: 1..original_stock),
    book_type: book_type,
    description: Faker::Lorem.paragraph(sentence_count: 30, random_sentences_to_add: 10),
    price: price,
    author_id: Author.pluck(:id).sample,
    category_id: Category.pluck(:id).sample,
    genre_id: Genre.pluck(:id).sample,
    language_id: Language.pluck(:id).sample)
end