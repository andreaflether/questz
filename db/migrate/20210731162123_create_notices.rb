# frozen_string_literal: true

class CreateNotices < ActiveRecord::Migration[5.2]
  def change
    create_table :notices do |t|
      t.text :details, null: false
      t.integer :reason, null: false
      t.belongs_to :user, foreign_key: true
      t.integer :given_by_id, null: false
      t.integer :noticeable_type, null: false

      t.timestamps
    end
  end
end
