# frozen_string_literal: true

class Api::Admin::MasterData::AuthorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found

  def index
    if query_params.blank?
      authors = Author.all
    else
      authors = Author.where("LOWER(name) LIKE ?", "%" + Author.sanitize_sql_like(query_params[:name].downcase) + "%")
    end

    render json: { data: authors }, status: :ok
  end

  def show
    author = Author.find_by!(id: params[:id])
    render json: { data: author }, status: :ok
  end

  def create
    author = Author.create(create_update_params)

    if author.valid?
      render_valid_create("Author")
    else
      render json: { message: "Failed to create author", error: author.errors }, status: :unprocessable_entity
    end
  end

  def update
    author = Author.find_by!(id: params[:id])
    author.update(create_update_params)
    render_valid_update("Author")
  end

  def destroy
    author = Author.find_by!(id: params[:id])
    author.destroy
    render_valid_delete("Author")
  end

  private

  def query_params
    params.permit(:name)
  end

  def create_update_params
    params.require(:data).permit(:name)
  end

  def render_record_not_found
    render json: { message: "Author not found" }, status: :not_found
  end
end
