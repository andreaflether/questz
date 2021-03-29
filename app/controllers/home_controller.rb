# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @questions = Question.all.includes([:user, { answers: [:user] }, :tags])
    @top_users = User.top_users
    @tags = current_user.all_following
  end
end
