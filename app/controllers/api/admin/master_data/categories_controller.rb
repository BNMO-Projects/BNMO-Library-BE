# frozen_string_literal: true

class Api::Admin::MasterData::CategoriesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found

  def index
    if query_params.blank?
      categories = Category.all
    else
      categories = Category.where("LOWER(name) LIKE ?", "%" + Category.sanitize_sql_like(query_params[:name].downcase) + "%")
    end

    render json: { data: categories }, status: :ok
  end

  def show
    category = Category.find_by!(id: params[:id])
    render json: { data: category }, status: :ok
  end

  def create
    category = Category.create(create_update_params)

    if category.valid?
      render_valid_create("Category")
    else
      render json: { message: "Failed to create category", error: category.errors }, status: :unprocessable_entity
    end
  end

  def update
    category = Category.find_by!(id: params[:id])
    category.update(create_update_params)
    render_valid_update("Category")
  end

  def destroy
    category = Category.find_by!(id: params[:id])
    category.destroy
    render_valid_delete("Category")
  end

  private

  def query_params
    params.permit(:name)
  end

  def create_update_params
    params.require(:data).permit(:name)
  end

  def render_record_not_found
    render json: { message: "Category not found" }, status: :not_found
  end
end
