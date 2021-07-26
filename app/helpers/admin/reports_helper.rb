module Admin::ReportsHelper
  def get_class_for_report_status(status)
    statuses = { closed: 'danger', opened: 'warning', ongoing: 'secondary', solved: 'success' }
    statuses[status.to_sym]
  end
end
