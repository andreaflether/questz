# frozen_string_literal: true

class AddCachedImpressionsToQuestions < ActiveRecord::Migration[5.2]
  def change
    change_table :questions do |t|
      t.integer :impressions_count, default: 0
    end
  end
end
