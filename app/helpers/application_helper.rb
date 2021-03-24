# frozen_string_literal: true

module ApplicationHelper
  def custom_flash_messages
    if flash.to_h.any?
      script = '<script>$(document).ready(function() {'
      flash.each do |type, message|
        script += "$.notyf.open({ type: '#{notyf_classes_for(type)}', message: '#{message}'})"
      end
      script += '})</script>'
      flash.clear
      flash.to_h.any? ? script.html_safe : ''
    end
  end

  def notyf_classes_for(type)
    types = { 'notice': 'success', 'info': 'info', 'alert': 'warning', 'error': 'error' }
    types[type.to_s]
  end

  def array_items_to_sentence_with_html(array, html_tag)
    raw array.map { |item| "<#{html_tag}>#{item}</#{html_tag}>" }.to_sentence
  end

  def user_vote(votable)
    case current_user.voted_as_when_voted_for(votable)
    when true
      'upvote'
    when false
      'downvote'
    else
      'none'
    end
  end

  def format_datetime(datetime)
    datetime.strftime('%b %d, %Y')
  end
end
