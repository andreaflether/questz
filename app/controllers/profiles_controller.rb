# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show]

  def show
    @solved_questions = @user.solved_questions
    render layout: 'profiles'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_profile
    @user = User.friendly.find(params[:id])
  end
end
