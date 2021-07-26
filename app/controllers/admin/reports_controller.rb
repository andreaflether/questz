module Admin
  class ReportsController < AdminController
    before_action :set_report, except: %i[index opened]
    before_action :get_reports, only: %i[index opened]

    # GET /admin/reports
    def index; end

    # GET /admin/reports/opened
    def opened
      @question_reports = @question_reports.opened
      @answer_reports = @answer_reports.opened
    end

    # GET /admin/reports/1
    def show; end

    # PATCH /admin/reports/1/assign
    def assign; end

    # PATCH /admin/reports/1/close
    def close; end

    # PATCH /admin/reports/1/solve
    def solve; end

    private 

    def set_report
      @report = Report.find_by(number: params[:number])
    end
    
    def get_reports
      @reports = Report.all.includes([:user, :reportable])
      @question_reports = @reports.where(reportable_type: 'Question')
      @answer_reports = @reports.where(reportable_type: 'Answer')
    end
  end
end
