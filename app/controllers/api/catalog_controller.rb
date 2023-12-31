# frozen_string_literal: true

class Api::CatalogController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found

  def index
    page = query_params[:currentPage].to_i
    limit = query_params[:limitPerPage].to_i
    offset = (page - 1) * limit

    base_query = Book.joins(:author)

    if required_params?(query_params)
      base_query = base_query
    else
      if query_params[:currentPage].present? && query_params[:limitPerPage].present?
        # Search queries with 5 possible options
        # Case-insensitive search for book title or author name
        # Equal search for category, genre, and language
        base_query = base_query.joins(:category, :genre, :language)
        base_query = base_query.where("LOWER(books.title) LIKE ?", "%" + Book.sanitize_sql_like(query_params[:searchQuery].downcase) + "%") unless query_params[:searchQuery].blank?
        base_query = base_query.where("LOWER(authors.name) LIKE ?", "%" + Author.sanitize_sql_like(query_params[:authorQuery].downcase) + "%") unless query_params[:authorQuery].blank?
        base_query = base_query.where("LOWER(categories.name) = ?", Category.sanitize_sql_like(query_params[:category].downcase)) unless query_params[:category].blank?
        base_query = base_query.where("LOWER(genres.name) = ?", Genre.sanitize_sql_like(query_params[:genre].downcase)) unless query_params[:genre].blank?
        base_query = base_query.where("LOWER(languages.name) = ?", Language.sanitize_sql_like(query_params[:language].downcase)) unless query_params[:language].blank?
      else
        return render json: { message: "Invalid parameters. currentPage or limitPerPage is missing" }, status: :unprocessable_entity
      end
    end

    if query_params[:bookType] === "ALL"
      @books = base_query.limit(limit).offset(offset).select("books.id, books.title, books.book_cover, books.original_stock, books.current_stock, books.book_type, books.price, authors.name AS author_name")
    else
      @books = base_query.where("books.book_type = ?", Book.sanitize_sql_like(query_params[:bookType])).limit(limit).offset(offset).select("books.id, books.title, books.book_cover, books.original_stock, books.current_stock, books.book_type, books.price, authors.name AS author_name")
    end


    total = base_query.count
    total_page = (total.to_f / limit).ceil
    metadata = { total: total, page: page, totalPage: total_page }

    render json: { data: @books, metadata: metadata }, status: :ok
  end

  def show
    book = Book.find_by!(id: params[:id])
    book = preprocess_book_output(book)

    render json: { data: book }, status: :ok
  end

  private

  def query_params
    params.permit(:currentPage, :limitPerPage, :bookType, :searchQuery, :authorQuery, :category, :genre, :language)
  end

  def required_params?(object)
    expected_keys = %w[currentPage limitPerPage]

    return false unless object.is_a?(ActionController::Parameters)

    object.keys.sort == expected_keys.sort
  end

  def preprocess_book_output(item)
    book = item.attributes.except("author_id", "category_id", "genre_id", "language_id")
    book["author_name"] = item.author.name
    book["category_name"] = item.category.name
    book["genre_name"] = item.genre.name
    book["language_name"] = item.language.name

    book
  end

  def render_record_not_found
    render json: { message: "Book not found" }, status: :not_found
  end
end
