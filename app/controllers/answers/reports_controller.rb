# frozen_string_literal: true

class Answers::ReportsController < ReportsController
  before_action :set_reportable
  before_action :user_owns_resource
  before_action :user_previously_reported

  private

  def set_reportable
    @reportable = Answer.find_by!(id: params[:answer_id])
    @question = @reportable.question
    @reportable_path = question_path(@reportable.question)
  end
end
