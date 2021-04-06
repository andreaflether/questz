class AddCachedFieldsToUser < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.integer :questions_count, default: 0
      t.integer :answers_count, default: 0
    end
  end
end
