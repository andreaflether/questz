# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :authenticate_user!

  def new
    @report = @reportable.reports.new
  end

  def create
    @report = @reportable.reports.new(report_params)

    @report.user = current_user

    if @report.save
      redirect_to @reportable_path, notice: t('controllers.reports.create')
    else
      render :new
    end
  end

  private

  def user_owns_resource
    if current_user == @reportable.user
      redirect_to @reportable_path, alert: t('controllers.reports.owned', reportable_type: @reportable.class)
    end
  end

  def user_previously_reported
    if current_user.check_for_reports(@reportable).any?
      redirect_to @reportable_path, alert: t('controllers.reports.reported', reportable_type: @reportable.class)
    end
  end

  # Only allow a list of trusted parameters through.
  def report_params
    params.require(:report).permit(:reason, :duplicate_id, :mod_attention_details)
  end
end
