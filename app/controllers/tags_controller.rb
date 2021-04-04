# frozen_string_literal: true

class TagsController < ApplicationController
  before_action :set_tag, only: %i[show follow unfollow]
  before_action :authenticate_user!, only: %i[follow unfollow]
  has_scope :alphabetic_order, type: :boolean, only: %i[index]
  has_scope :newest, type: :boolean, only: %i[index]

  # GET /tags
  def index
    @tags = apply_scopes(Tag).most_used
  end

  # GET /tags/search
  def search
    @tags = if params[:search]
              Tag.where('lower(name) LIKE lower(?)',
                        "%#{params[:search]}%")
            else
              Tag.most_used
            end
    @tags = @tags.page(params[:page])
  end

  # GET /tags/1
  def show
    @questions = Question.tagged_with(@tag)
                         .includes(%i[tags tag_taggings user])
                         .order(cached_votes_up: :desc)
    @questions_count = Question.count_by_status_in_tag(@tag)
    @top_users = User.top_answerers_in_tag(@tag.name)
  end

  # PATCH /tags/1/follow
  def follow
    current_user.follow(@tag)
    @tag.create_activity key: 'tag.follow', owner: current_user
    render 'tags/js/follow'
  end

  # PATCH /tags/1/unfollow
  def unfollow
    current_user.stop_following(@tag)
    @tag.create_activity key: 'tag.unfollow', owner: current_user
    render 'tags/js/follow'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tag
    @tag = Tag.find(params[:id])
  end
end
