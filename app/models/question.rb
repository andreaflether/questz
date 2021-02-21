# frozen_string_literal: true

# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  status     :integer          default("unanswered")
#  title      :string           default(""), not null
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
  has_many :answers, dependent: :destroy

  validates :title, length: { in: 15..200, allow_blank: true }, presence: true
end
