# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @questions = if user_signed_in?
                   Question.with_user_followed_tags(current_user)
                 else
                   Question.most_voted
                 end
    @questions = @questions.includes(%i[tags user])
    @top_users = User.top_users
    @tags = current_user.all_following
  end
end
