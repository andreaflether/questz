# frozen_string_literal: true

module ApplicationHelper
  def custom_flash_messages
    if flash.to_h.any?
      script = '<script>$(document).ready(function() {'
      flash.each do |type, message|
        script += "$.notyf.open({ type: '#{notyf_classes_for(type)}', message: '#{message}'})"
      end
      script += '})</script>'
      script.html_safe
    end
  end

  def notyf_classes_for(type)
    types = { 'notice' => 'success', 'info' => 'info', 'alert' => 'warning', 'error' => 'error' }
    types[type.to_s]
  end
end
