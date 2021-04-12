# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[show]
  before_action :authenticate_user!, only: %i[update_avatar notifications]

  def show
    @solved_questions = @user.solved_questions
    @tags = Question.user_interacted(@user)
                    .tag_counts_on(:tags, order: 'count DESC', limit: 10)
    @activities = PublicActivity::Activity
                  .where(owner: @user)
                  .order(created_at: :desc)
                  .includes([:trackable])
                  .page(params[:page])
    render layout: 'default'
  end

  def update_avatar
    @user = User.find(params[:user_id])
    @user.update(profile_params)

    head :ok
  end

  def notifications
    @activities = PublicActivity::Activity.where(owner: current_user, trackable_type: %w[Question Answer])
    @activities_days = @activities.group_by { |activity| activity.created_at.to_date }
    # @experience_info = current_user.
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
