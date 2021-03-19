# frozen_string_literal: true

class VotablesController < ApplicationController
  before_action :force_js
  before_action :set_votable 

  # PATCH /questions/1/like
  def like 
    @votable.liked_by current_user
    render_votable_partial
  end
  
  # PATCH /questions/1/unlike
  def unlike 
    @votable.unliked_by current_user
    render_votable_partial 
  end
  
  # PATCH /questions/1/dislike
  def dislike 
    @votable.disliked_by current_user
    render_votable_partial
  end
  
  # PATCH /questions/1/undislike
  def undislike 
    @votable.undisliked_by current_user
    render_votable_partial 
  end

  private 

  def force_js 
    request.format = :js
  end

  def set_votable
    model = controller_name.singularize.camelize.constantize
    @votable = model.find(params[:id])
  end

  def render_votable_partial
    render 'concerns/find_or_replace_vote', locals: { votable: @votable, votable_type: controller_name.singularize }
  end
end
