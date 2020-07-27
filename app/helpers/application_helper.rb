module ApplicationHelper
  def devise_action(action, controller)
    case action
    when "new"
      case controller
      when "passwords"
        "Recuperar senha"
      when "registrations"
        "Criar conta"
      when "sessions"
        "Entrar"
      end
    when "edit"
      case controller
      when "registrations"
        "Editar informações de conta"
      when "passwords"
        "Mudar senha"
      end
    when "create"
      case controller
      when "registrations"
        "Criar Conta"
      when "passwords"
        "Recuperar senha"
      when "registrations"
        "Criar conta"
      when "sessions"
        "Entrar"
      end
    end
  end
end
