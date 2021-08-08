# frozen_string_literal: true

class AdminController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!, except: %i[index show upvote downvote search]
  load_and_authorize_resource

  def index
    @questions = Question.group_by_day_of_week(:created_at, format: "%a").count
    @tags = Question.tag_counts_on(:tags).group(:name).sum(:taggings_count)
    @users = User.group_by_day(:created_at).count
  end
end
