# frozen_string_literal: true

# == Schema Information
#
# Table name: answers
#
#  id         :integer          not null, primary key
#  body       :text             default(""), not null
#  chosen     :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :answer do
    chosen { false }
    body { Faker::Lorem.paragraph_by_chars(number: 200, supplemental: true) }
  end
end
