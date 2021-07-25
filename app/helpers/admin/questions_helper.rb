module Admin::QuestionsHelper
  def get_class_for_question_status(status)
    classes = { unanswered: 'secondary', answered: 'primary', closed: 'warning' }
    classes[status.to_sym]
  end

  def render_close_modal(question)
    render partial: 'admin/questions/close_question_form', locals: { question: question }
  end
end
