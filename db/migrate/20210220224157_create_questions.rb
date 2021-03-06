# frozen_string_literal: true

class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.integer :status, default: 0, comment: '0: Unanswered, 1: Answered, 2: Closed'
      t.string :title, null: false, default: ''
      t.text :body, null: false, default: ''
      t.integer :answers_count, default: 0
      t.datetime :answered_on
      t.string :slug, unique: true

      t.timestamps
    end
  end
end
