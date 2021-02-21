# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  content    :text
#  status     :integer          default("unanswered")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_questions_on_user_id  (user_id)
#
FactoryBot.define do
  factory :question do
    content { Faker::Lorem.paragraph_by_chars(number: 150, supplemental: true) }
    status { 0 }
    user
  end
end
