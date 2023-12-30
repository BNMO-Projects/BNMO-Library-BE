# frozen_string_literal: true

class Api::CatalogMetadata::CategoriesController < ApplicationController
  def index
    if query_params[:name].present?
      @category = Category.where("LOWER(name) LIKE ?", "%" + Category.sanitize_sql_like(query_params[:name].downcase) + "%").select("id, name").limit(5)
    else
      @category = Category.select("id, name").limit(5).all
    end

    render json: { data: @category }, status: :ok
  end

  private

  def query_params
    params.permit(:name)
  end
end
