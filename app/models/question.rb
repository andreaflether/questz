# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  content    :text
#  status     :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Question < ApplicationRecord
  enum status: {
    not_answered: 0, 
    answered: 1,
    closed: 2
  }

  validates_length_of :content, in: 10..200
end
