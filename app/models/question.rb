# frozen_string_literal: true

# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  content    :text             default(""), not null
#  status     :integer          default("unanswered")
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
    unanswered: 0,
    answered: 1,
    closed: 2
  }

  belongs_to :user

  validates :content, length: { in: 10..200, allow_blank: true }, presence: true
end
