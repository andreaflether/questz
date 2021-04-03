# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :edit_user_path?
  layout :layout_by_resource

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to main_app.root_url, alert: exception.message }
      format.js   { render 'errors/error', locals: { message: "You're not allowed to perform this action." } }
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
end
