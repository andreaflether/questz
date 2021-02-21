# frozen_string_literal: true

class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.boolean :chosen
      t.text :content

      t.timestamps
    end
  end
end
