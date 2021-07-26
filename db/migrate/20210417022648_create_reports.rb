# frozen_string_literal: true

class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.integer :user_id
      t.string :number, unique: true
      t.integer :reason
      t.integer :status, default: 1 # Opened
      t.string :mod_attention_details
      t.integer :duplicate_id
      t.integer :assigned_user_id
      t.text :closing_notice_details

      t.timestamps
    end
  end
end
