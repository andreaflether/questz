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
#  user_id     :integer
#
# Indexes
#
#  index_answers_on_question_id  (question_id)
#  index_answers_on_user_id      (user_id)
#
FactoryBot.define do
  factory :answer do
    chosen { false }
    body { Faker::Lorem.paragraph_by_chars(number: 200, supplemental: true) }
    question
    user
  end
end
