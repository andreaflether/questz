# frozen_string_literal: true

class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.integer :user_id
      t.integer :reason
      t.string :mod_attention_details
      t.integer :duplicate_id

      t.timestamps
    end
  end
end
