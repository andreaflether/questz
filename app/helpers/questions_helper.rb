# frozen_string_literal: true

module QuestionsHelper
  def status_to_html(status)
    statuses = {
      unanswered: "<i class='fas fa-question-circle'></i>",
      answered: "<i class='fas fa-check'></i>",
      closed: "<i class='fas fa-ban'></i>"
    }
    "#{statuses[status.to_sym]} &nbsp;#{status.capitalize}"
  end
end
