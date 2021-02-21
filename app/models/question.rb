# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  content    :text
#  status     :integer          default("not_answered")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_questions_on_user_id  (user_id)
#
class Question < ApplicationRecord
  enum status: {
    not_answered: 0, 
    answered: 1,
    closed: 2
  }

  belongs_to :user

  validates_length_of :content, in: 10..200
end
