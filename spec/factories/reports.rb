# frozen_string_literal: true

# == Schema Information
#
# Table name: reports
#
#  id                    :integer          not null, primary key
#  mod_attention_details :string
#  reason                :integer
#  report_number         :string
#  reportable_type       :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  duplicate_id          :integer
#  reportable_id         :integer
#  user_id               :integer
#
# Indexes
#
#  index_reports_on_reportable_type_and_reportable_id  (reportable_type,reportable_id)
#
FactoryBot.define do
  factory :report do
    user
    for_question
    reason { rand(1..7) }

    trait :for_question do
      association(:reportable, factory: :question)
    end

    trait :for_answer do
      association(:reportable, factory: :answer)
    end

    trait :duplicated_question do
      duplicate { create(:question) }
    end

    trait :needs_mod_intervention do
      mod_attention_details { Faker::Lorem.paragraph_by_chars(number: 150, supplemental: true) }
    end
  end
end
