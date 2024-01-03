# frozen_string_literal: true

class Api::WishlistController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found

  def index
    page = query_params[:currentPage].to_i
    limit = query_params[:limitPerPage].to_i
    offset = (page - 1) * limit

    base_query = Wishlist.joins(book: :author).where("wishlists.user_id = ?", Wishlist.sanitize_sql_like(@user_id))

    if required_params?(query_params)
      base_query = base_query
    else
      if query_params[:currentPage].present? && query_params[:limitPerPage].present? && query_params[:bookType].present?
        # Search queries with 1 possible option
        # Case-insensitive search for book title
        base_query = base_query.where("LOWER(books.title) LIKE ?", "%" + Book.sanitize_sql_like(query_params[:searchQuery].downcase) + "%") unless query_params[:searchQuery].blank?
      else
        return render json: { message: "Invalid parameters. currentPage, limitPerPage, or bookType is missing" }, status: :unprocessable_entity
      end
    end

    if query_params[:bookType] === "ALL"
      wishlists = base_query.limit(limit).offset(offset).select("wishlists.id, wishlists.created_at, books.title, books.book_cover, books.original_stock, books.current_stock, books.book_type, books.price, authors.name AS author_name")
    else
      wishlists = base_query.where("books.book_type = ?", Book.sanitize_sql_like(query_params[:bookType])).limit(limit).offset(offset).select("wishlists.id, wishlists.created_at, books.title, books.book_cover, books.original_stock, books.current_stock, books.book_type, books.price, authors.name AS author_name")
    end


    total = base_query.count
    total_page = (total.to_f / limit).ceil
    metadata = { total: total, page: page, totalPage: total_page }

    render json: { data: wishlists, metadata: metadata }, status: :ok
  end

  def create
    wishlist = Wishlist.create(book_id: create_params[:book_id], user_id: @user_id)

    if wishlist.valid?
      render_valid_create("Wishlist")
    else
      render json: { message: "Failed to create new wishlist", error: wishlist.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    wishlist = Wishlist.find_by!(id: params[:id])
    wishlist.destroy
    render_valid_delete("Wishlist")
  end

  private

  def query_params
    params.permit(:currentPage, :limitPerPage, :bookType, :searchQuery)
  end

  def create_params
    params.require(:data).permit(:book_id)
  end

  def required_params?(object)
    expected_keys = %w[currentPage limitPerPage bookType]

    return false unless object.is_a?(ActionController::Parameters)

    object.keys.sort == expected_keys.sort
  end

  def render_record_not_found
    render json: { message: "Wishlist not found" }, status: :not_found
  end
end
