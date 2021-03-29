# frozen_string_literal: true

class TagsController < ApplicationController
  before_action :set_tag, only: %i[show follow unfollow]
  before_action :authenticate_user!, only: %i[follow unfollow]

  # GET /tags
  def index
    @tags = ActsAsTaggableOn::Tag.most_used
  end

  # GET /tags/1
  def show
    @questions = Question.filter_by_tag(@tag)
                         .includes(%i[tags tag_taggings user])
                         .order(cached_votes_up: :desc)
    @top_users = User.top_answerers_in_tag(@tag.name)
  end

  # PATCH /tags/1/follow
  def follow
    current_user.follow(@tag)
  end

  # PATCH /tags/1/unfollow
  def unfollow; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tag
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
  end
end
