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
covers = [
  { "link" => "https://firebasestorage.googleapis.com/v0/b/bnmo-projects.appspot.com/o/book-cover%2F215583a4-71ab-484c-b4c5-547b1ab2c2e8-potter%203.jpg?alt=media&token=4593e864-05cb-47b6-863f-1baf7a51b1d1",
    "name" => "book-cover/215583a4-71ab-484c-b4c5-547b1ab2c2e8-potter 3.jpg" },
  { "link" => "https://firebasestorage.googleapis.com/v0/b/bnmo-projects.appspot.com/o/book-cover%2F8ef95277-b0c3-4eb9-ba71-3aa9f715c1ed-5cm.jpg?alt=media&token=94234bd0-7021-4a51-a022-8e568fec2000",
    "name" => "book-cover/8ef95277-b0c3-4eb9-ba71-3aa9f715c1ed-5cm.jpg" },
  { "link" => "https://firebasestorage.googleapis.com/v0/b/bnmo-projects.appspot.com/o/book-cover%2F86b5cb36-eedb-45aa-8899-82961f780c58-last%20summer.jpg?alt=media&token=487094d8-820d-4398-88a8-a65f525a3678",
    "name" => "book-cover/86b5cb36-eedb-45aa-8899-82961f780c58-last summer.jpg" },
  { "link" => "https://firebasestorage.googleapis.com/v0/b/bnmo-projects.appspot.com/o/book-cover%2F00ca1fa0-5728-4dde-8558-55e5249184e3-potter%206.jpg?alt=media&token=2c5b80e7-56dc-47c4-9e38-0286998427f3",
    "name" => "book-cover/00ca1fa0-5728-4dde-8558-55e5249184e3-potter 6.jpg" },
  { "link" => "https://firebasestorage.googleapis.com/v0/b/bnmo-projects.appspot.com/o/book-cover%2F812084d3-01fd-4094-8bbc-dccd36498ec0-potter%204.jpg?alt=media&token=44ea96f5-0e48-4766-a581-9c9cb9ded5ab",
    "name" => "book-cover/812084d3-01fd-4094-8bbc-dccd36498ec0-potter 4.jpg" },
]

(1..200).each do
  book_type = types.sample
  original_stock = Faker::Number.within(range: 1..100)
  price = nil
  if book_type === "ONSALE"
    price = Faker::Number.within(range: 10000..500000)
  end

  chosen_cover = covers.sample
  Book.create!(
    title: Faker::Book.title,
    publication_year: Faker::Date.between(from: 2.years.ago.to_date, to: Date.today),
    isbn: Faker::Code.unique.isbn(base: 13),
    book_cover: chosen_cover["link"],
    cover_file_name: chosen_cover["name"],
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