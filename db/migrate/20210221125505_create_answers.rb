# frozen_string_literal: true

class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.boolean :chosen, default: false
      t.text :body, null: false, default: ''

      t.timestamps
    end
  end
end
