# frozen_string_literal: true

module ApplicationHelper
  def devise_action(action, controller)
    case action
    when 'new', 'create'
      case controller
      when 'passwords'
        'Recuperar senha'
      when 'registrations'
        'Criar conta'
      when 'sessions'
        'Entrar'
      end
    when 'edit', 'update'
      case controller
      when 'registrations'
        'Editar informações de conta'
      when 'passwords'
        'Mudar senha'
      end
    end
  end
end
