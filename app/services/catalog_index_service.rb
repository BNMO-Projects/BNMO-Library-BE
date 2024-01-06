# frozen_string_literal: true

class CatalogIndexService < BaseServiceObject
  def initialize(query_params)
    super()
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
    base_query = Book.joins(:author,:category, :genre, :language)
    base_query = apply_filters(base_query)
    books = base_query.limit(limit).offset(offset).select("books.id, books.title, books.book_cover, books.original_stock, books.current_stock, books.book_type, books.price, authors.name AS author_name")

    self.result = { data: books, metadata: pagination_metadata(base_query.count, page, limit) }

    self
  end

  private

  def filter_by_title(query)
    query.where("LOWER(books.title) LIKE ?", "%#{sanitize(@query_params[:searchQuery])}%")
  end

  def filter_by_author(query)
    query.where("LOWER(authors.name) LIKE ?", "%#{sanitize(@query_params[:authorQuery])}%")
  end

  def filter_by_category(query)
    query.where("LOWER(categories.name) = ?", sanitize(@query_params[:category]))
  end

  def filter_by_genre(query)
    query.where("LOWER(genres.name) = ?", sanitize(@query_params[:genre]))
  end

  def filter_by_language(query)
    query.where("LOWER(languages.name) = ?", sanitize(@query_params[:language]))
  end

  def filter_by_book_type(query)
    query.where("books.book_type = ?", ActiveRecord::Base.sanitize_sql_like(@query_params[:bookType]))
  end

  def sanitize(value)
    ActiveRecord::Base.sanitize_sql_like(value.downcase)
  end

  def apply_filters(query)
    query = filter_by_book_type(query) unless @query_params[:bookType] === "ALL"
    query = filter_by_title(query) if @query_params[:searchQuery].present?
    query = filter_by_author(query) if @query_params[:authorQuery].present?
    query = filter_by_category(query) if @query_params[:category].present?
    query = filter_by_genre(query) if @query_params[:genre].present?
    query = filter_by_language(query) if @query_params[:language].present?

    query
  end
end
