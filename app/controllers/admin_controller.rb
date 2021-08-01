# frozen_string_literal: true

class AdminController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!, except: %i[index show upvote downvote search]
  load_and_authorize_resource

  def index; end
end
