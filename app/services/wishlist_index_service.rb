# frozen_string_literal: true

class WishlistIndexService < BaseServiceObject
  def initialize(user_id, query_params)
    super()
    @user_id = user_id
    @query_params = query_params
  end

  def call
    # Continue query unless required parameters are missing
    unless required_params?(@query_params, %w[currentPage limitPerPage bookType])
      self.errors = ["Missing parameters. currentPage, limitPerPage, or bookType is missing"]
      return self
    end

    # Pull pagination data
    page = @query_params[:currentPage].to_i
    limit = @query_params[:limitPerPage].to_i
    offset = (page - 1) * limit

    # Do query
    base_query = Wishlist.joins(book: [:author, :category, :genre, :language]).where("wishlists.user_id = ?", sanitize(@user_id))
    base_query = apply_filters(base_query)
    books = base_query.limit(limit).offset(offset).select("wishlists.id, wishlists.created_at, books.id AS book_id, books.title, books.publication_year, books.book_cover, books.original_stock, books.current_stock, books.description, books.book_type, books.price, authors.name AS author_name, categories.name AS category_name, genres.name AS genre_name, languages.name AS language_name")

    self.result = { data: books, metadata: pagination_metadata(base_query.count, page, limit) }

    self
  end

  private

  def filter_by_title(query)
    query.where("LOWER(books.title) LIKE ?", "%#{sanitize(@query_params[:searchQuery])}%")
  end

  def filter_by_book_type(query)
    query.where("books.book_type = ?", sanitize(@query_params[:bookType]))
  end

  def sanitize(value)
    ActiveRecord::Base.sanitize_sql_like(value.downcase)
  end

  def apply_filters(query)
    query = filter_by_book_type(query) unless @query_params[:bookType] === "ALL"
    query = filter_by_title(query) if @query_params[:searchQuery].present?

    query
  end
end
