# frozen_string_literal: true

module ApplicationHelper
  # def custom_flash_messages
  #   flash_messages = []

  #   # Overall flash messages
  #   flash.each do |type, message|
  #     message_type(type)
  #     text = "
  #     <script>
  #       notif.#{type}('#{message}'); 
  #     </script>
  #     "
  #     flash_messages << text.html_safe
  #   end
  #   flash_messages.join("\n").html_safe
  # end

  def custom_flash_messages
    if flash.to_h.any? 
      script = "<script>$(document).ready(function() {"
      flash.each do |type, message|
        # script += "$.notyf.#{notyf_classes_for(type)}('#{message}');" if message
        script += "$.notyf.open({ type: '#{notyf_classes_for(type)}', message: '#{message}'})"
      end
      script += "})</script>"
      script.html_safe
    end
  end

  def devise_action(action, controller)
    case action
    when 'new', 'create'
      case controller
      when 'passwords'
        'Forgot your password?'
      when 'registrations'
        'Sign up'
      when 'sessions'
        'Sign in'
      end
    when 'edit', 'update'
      case controller
      when 'registrations'
        'Edit user info'
      when 'passwords'
        'Change password'
      end
    end
  end
  
  def notyf_classes_for(type)
    types = { 'notice' => 'success', 'info' => 'info', 'alert' => 'warning', 'error' => 'error' }
    types["#{type}"]
  end
end
