# frozen_string_literal: true

module ReportsHelper
  def status_to_class(status)
    statuses = { pending: 'secondary', ongoing: 'info', closed: 'danger', solved: 'primary' }
    statuses[status.to_sym]
  end
end
