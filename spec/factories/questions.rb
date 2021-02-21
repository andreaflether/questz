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
FactoryBot.define do
  factory :question do
    title { Faker::Lorem.paragraph_by_chars(number: 200, supplemental: true) }
    status { 0 }
    user
  end
end
