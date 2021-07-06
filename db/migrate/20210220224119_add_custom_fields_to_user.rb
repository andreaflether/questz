# frozen_string_literal: true

class AddCustomFieldsToUser < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.string :username, null: false, default: ''
      t.string :name, null: false, default: ''
      t.integer :level, null: false, default: 1

      t.integer :role, null: false, default: 1 # Normal user
      t.datetime :changed_role_on 
    end
  end
end
