# frozen_string_literal: true

class AddExpFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :experience, :integer, default: 0
    add_column :users, :level, :integer, default: 0
  end
end
