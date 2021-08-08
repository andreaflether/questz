# frozen_string_literal: true

# == Schema Information
#
# Table name: reports
#
#  id                     :bigint           not null, primary key
#  closing_notice_details :text
#  mod_attention_details  :string
#  number                 :string
#  reason                 :integer
#  reportable_type        :string
#  solved_at              :datetime
#  status                 :integer          default("pending")
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  assigned_user_id       :integer
#  duplicate_id           :integer
#  reportable_id          :bigint
#  solved_by_id           :integer
#  user_id                :integer
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
