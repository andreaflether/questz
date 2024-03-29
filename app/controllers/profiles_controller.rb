# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[show]
  before_action :authenticate_user!, only: %i[update_avatar reputation reports]

  def show
    @solved_questions = @user.solved_questions
    @tags = Question.user_interacted(@user)
                    .tag_counts_on(:tags, order: 'count DESC', limit: 10)
    @activities = PublicActivity::Activity
                  .where(owner: @user)
                  .where.not('key SIMILAR TO ?', '%answer.destroy%|%vote%|%report%')
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

  def reputation
    @activities = PublicActivity::Activity
                  .where(owner: current_user, trackable_type: %w[Question Answer])
                  .includes(:trackable)
    @activities_days = @activities.order(created_at: :desc)
                                  .group_by { |activity| activity.created_at.to_date }
    @weekly_experience = current_user.points.where('created_at >= ?', 1.week.ago)
  end

  def reports
    @reports = current_user.reports.page(params[:page])
    @notices = current_user.notices
  end

  def community
    @users = User.all
    @users = params[:tab] ? sanitize_filter_params : @users.newest
    @users = @users.page(params[:page]).per(3)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_profile
    @user = User.friendly.find(params[:id])
  end

  def profile_params
    params.require(:user).permit(:avatar, :authencity_token)
  end

  def sanitize_filter_params
    if %w[top_users moderators].include?(params[:tab])
      @users_to_exihibt = @users.public_send(params[:tab])
      @users = @users_to_exihibt
    else
      @message = I18n.t('messages.views.not_a_valid_filter', filter: params[:tab])
    end
  end
end
