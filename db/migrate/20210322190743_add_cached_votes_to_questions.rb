# frozen_string_literal: true

class AddCachedVotesToQuestions < ActiveRecord::Migration[5.2]
  def change
    change_table :questions do |t|
      t.integer :cached_votes_total, default: 0
      t.integer :cached_votes_score, default: 0
      t.integer :cached_votes_up, default: 0
      t.integer :cached_votes_down, default: 0
    end
  end
end
