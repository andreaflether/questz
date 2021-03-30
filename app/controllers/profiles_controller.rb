# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show]
  before_action :authenticate_user!, only: [:update_avatar]

  def show
    @solved_questions = @user.solved_questions
    @tags = @user.questions.tag_counts_on(:tags)
    render layout: 'profiles'
  end

  def update_avatar
    @user = User.find(params[:user_id])
    @user.update(profile_params)

    head :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_profile
    @user = User.friendly.find(params[:id])
  end

  def profile_params
    params.require(:user).permit(:avatar, :authencity_token)
  end
end
