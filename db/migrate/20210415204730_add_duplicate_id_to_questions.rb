# frozen_string_literal: true

class AddDuplicateIdToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :duplicate_id, :integer
  end
end
