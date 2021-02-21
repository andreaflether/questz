# frozen_string_literal: true

# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  body        :text             default(""), not null
#  chosen      :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  question_id :integer
#
# Indexes
#
#  index_answers_on_question_id  (question_id)
#
class Answer < ApplicationRecord
  belongs_to :question

  validates :body, length: { in: 15..30_000, allow_blank: true }, presence: true
end
