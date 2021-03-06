# frozen_string_literal: true

class AddUserToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_reference :answers, :user, foreign_key: true
  end
end
