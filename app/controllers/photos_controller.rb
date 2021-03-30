# frozen_string_literal: true

class PhotosController < ApplicationController
  before_action :set_photo, only: %i[show edit update destroy]

  # GET /photos/1.json
  def show; end

  # POST /photos.json
  def create
    @photo = Photo.new(photo_params)

    if @photo.save
      render :show, status: :created, location: @photo
    else
      render json: @photo.errors, status: :unprocessable_entity
    end
  end

  # DELETE /photos/1.json
  def destroy
    @photo.destroy
    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_photo
    @photo = Photo.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def photo_params
    params.require(:photo).permit(:image)
  end
end
