# frozen_string_literal: true

class Questions::ReportsController < ReportsController
  before_action :set_reportable
  before_action :user_owns_resource
  before_action :user_previously_reported

  private

  def set_reportable
    @reportable = Question.find(params[:question_id])
    @reportable_path = question_path(@reportable)
  end
end
