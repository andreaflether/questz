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

  def point_classes_for(key)
    get_points_for_key(key).to_i.positive? ? 'exp-up' : 'exp-down'
  end

  def get_points_for_key(key)
    format('%+d', t("honor.exp.#{key}"))
  end
end
