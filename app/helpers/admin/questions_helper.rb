module Admin::QuestionsHelper
  def get_class_for_question_status(status)
    classes = { unanswered: 'secondary', answered: 'primary', closed: 'warning' }
    classes[status.to_sym]
  end
end
