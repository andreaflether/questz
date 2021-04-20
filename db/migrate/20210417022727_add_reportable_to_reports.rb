# frozen_string_literal: true

class AddReportableToReports < ActiveRecord::Migration[5.2]
  def change
    add_reference :reports, :reportable, polymorphic: true
  end
end
