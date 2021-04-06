# frozen_string_literal: true

class AddCustomFieldsToUser < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.string :username, null: false, default: ''
      t.string :name, null: false, default: ''
    end
  end
end
