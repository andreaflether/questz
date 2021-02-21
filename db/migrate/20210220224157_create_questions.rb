class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.integer :status, default: 0, comment: '0: Unanswered, 1: Answered, 2: Closed'
      t.text :content

      t.timestamps
    end
  end
end