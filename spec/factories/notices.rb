# == Schema Information
#
# Table name: notices
#
#  id              :integer          not null, primary key
#  details         :text             not null
#  noticeable_type :integer          not null
#  reason          :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  given_by_id     :integer          not null
#  user_id         :integer
#
# Indexes
#
#  index_notices_on_user_id  (user_id)
#
FactoryBot.define do
  factory :notice do
    details { "MyText" }
    reason { 1 }
    user { nil }
    given_by_id { "MyString" }
  end
end
