# frozen_string_literal: true

# == Schema Information
#
# Table name: questions
#
#  id                                            :bigint           not null, primary key
#  answered_on                                   :datetime
#  answers_count                                 :integer          default(0)
#  body                                          :text             default(""), not null
#  cached_votes_down                             :integer          default(0)
#  cached_votes_score                            :integer          default(0)
#  cached_votes_total                            :integer          default(0)
#  cached_votes_up                               :integer          default(0)
#  closed_at                                     :datetime
#  closing_notice                                :integer
#  impressions_count                             :integer          default(0)
#  slug                                          :string
#  status(0: Unanswered, 1: Answered, 2: Closed) :integer          default("unanswered")
#  title                                         :string           default(""), not null
#  created_at                                    :datetime         not null
#  updated_at                                    :datetime         not null
#  duplicate_id                                  :integer
#  user_id                                       :bigint
#
# Indexes
#
#  index_questions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :question do
    title { Faker::Lorem.paragraph_by_chars(number: 150, supplemental: true) }
    body { Faker::Lorem.paragraph_by_chars(number: rand(300..500), supplemental: true) }
    tag_list { 'test' }
    user

    # after(:create) { |question| question.update(tag_list: 'test') }
  end
end
