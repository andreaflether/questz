# frozen_string_literal: true

module QuestionsHelper
  def user_asked?(question)
    question.user.id == current_user.id
  end
end
