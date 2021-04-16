# frozen_string_literal: true

class AddClosingFieldsToQuestion < ActiveRecord::Migration[5.2]
  def change
    change_table :questions do |t|
      t.integer   :closing_notice
      t.datetime  :closed_at
    end
  end
end
