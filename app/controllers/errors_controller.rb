# frozen_string_literal: true

class ErrorsController < ApplicationController
  def not_found
    render status: :bad_request
  end

  def internal_server_error
    render status: :internal_server_error
  end

  def unprocessable_entity
    render status: :unprocessable_entity
  end
end
