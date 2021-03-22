# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, only: [:update_avatar]
  helper_method :edit_user_path?
  layout :layout_by_resource

  def update_avatar
    @user = User.find(params[:user_id])
    @user.update(avatar_params)

    respond_to do |format|
      format.json { head :ok }
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name username])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name username avatar])
  end

  private

  def layout_by_resource
    devise_controller? && !edit_user_path? ? 'devise' : 'application'
  end

  def edit_user_path?
    controller_name == 'registrations' && %w[edit update].include?(action_name)
  end

  def avatar_params
    params.require(:user).permit(:avatar, :authencity_token)
  end
end
