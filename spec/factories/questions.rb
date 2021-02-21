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
FactoryBot.define do
  factory :question do
    content { Faker::Lorem.paragraph_by_chars(number: 150, supplemental: true) }
    status { 0 }
  end
end
