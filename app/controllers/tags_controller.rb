# frozen_string_literal: true

class TagsController < ApplicationController
  before_action :set_tag, only: [:show]

  def index
    @tags = ActsAsTaggableOn::Tag.all
  end

  def show
    @questions = Question.filter_by_tag(@tag)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tag
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
  end
end
