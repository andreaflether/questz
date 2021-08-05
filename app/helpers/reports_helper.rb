# frozen_string_literal: true

module ReportsHelper
  def status_to_class(status)
    statuses = { pending: 'secondary', ongoing: 'info', closed: 'danger', solved: 'success' }
    statuses[status.to_sym]
  end

  def handle_user_info(assigned_user)
    assigned_user ? "#{assigned_user.name} (@#{assigned_user.username})" : '-'
  end
end
