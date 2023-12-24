# frozen_string_literal: true

class Api::Admin::MasterData::LanguagesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found

  def index
    if query_params.blank?
      languages = Language.all
    else
      languages = Language.where("LOWER(name) LIKE ?", "%" + Language.sanitize_sql_like(query_params[:name].downcase) + "%")
    end

    render json: { data: languages }, status: :ok
  end

  def show
    language = Language.find_by!(id: params[:id])
    render json: { data: language }, status: :ok
  end

  def create
    language = Language.create(name: create_params[:name])

    if language.valid?
      render_valid_json("Language created successfully", :created)
    else
      render json: { message: "Failed to create language", error: language.errors }, status: :unprocessable_entity
    end
  end

  def update
    language = Language.find_by!(id: params[:id])
    language.update(update_params)
    render_valid_json("Language updated successfully", :ok)
  end

  def destroy
    language = Language.find_by!(id: params[:id])
    language.destroy
    render_valid_json("Language deleted successfully", :ok)
  end

  private

  def query_params
    params.permit(:name)
  end

  def create_params
    params.require(:data).permit(:name)
  end

  def update_params
    params.require(:data).permit(:name)
  end

  def render_record_not_found
    render json: { message: "Language not found" }, status: :not_found
  end
end
