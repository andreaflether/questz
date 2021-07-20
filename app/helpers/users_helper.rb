# frozen_string_literal: true

module UsersHelper
  def get_icon_class_for(role)
    roles = { mod: 'fa-shield-alt', adm: 'fa-cog' }
    roles[role.to_sym]
  end
end
