# frozen_string_literal: true

module Admin
  class ReportsController < AdminController
    before_action :set_report, except: %i[index opened]
    before_action :get_reports, only: %i[index opened]
    load_and_authorize_resource

    # GET /admin/reports
    def index
      @query = Report.ransack(params[:query])
      @reports = @query.result
                       .page(params[:page])
                       .includes(%i[user assigned_user])
    end

    # GET /admin/reports/opened
    def opened
      @question_reports = @question_reports.pending
      @answer_reports = @answer_reports.pending
    end

    # GET /admin/reports/1
    def show; end

    # PATCH /admin/reports/1/assign
    def assign
      if @report.update(assigned_user: current_user)
        redirect_to request.referrer, notice: 'atribuido com sucesso'
      else
        redirect_to request.referrer, flash: { error: 'flopou' }
      end
    end

    # PATCH /admin/reports/1/close
    def close
      if @report.update(report_params.merge(solved_by: current_user))
        redirect_to request.referrer, notice: I18n.t('controllers.reports.close')
      else
        redirect_to request.referrer, flash: { error: @report.errors.full_messages.first }
      end
    end

    # PATCH /admin/reports/1/solve
    def solve
      if @report.update(status: 'solved', solved_by: current_user)
        redirect_to request.referrer, notice: I18n.t('controllers.reports.solve')
      else
        redirect_to request.referrer, flash: { error: @report.errors.full_messages.first }
      end
    end

    # GET /admin/reports/1/close_modal
    def close_modal; end

    private

    def set_report
      @report = Report.find_by(number: params[:number])
    end

    def get_reports
      @reports = Report.all.includes(%i[user reportable])
      @question_reports = @reports.where(reportable_type: 'Question')
      @answer_reports = @reports.where(reportable_type: 'Answer')
    end

    def report_params
      params.require(:report).permit(:closing_notice_details, :status)
    end
  end
end
