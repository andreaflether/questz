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
class Notice < ApplicationRecord
  belongs_to :user, counter_cache: true
  belongs_to :given_by, class_name: 'User'

  enum reason: {
    spam: 1,
    unfriendly: 2,
    abusive: 3,
  }

  enum noticeable_type: {
    question: 1,
    answer: 2
  }

  after_create :ban_user
  validates :details, presence: true
  validates :noticeable_type, presence: true
  validates :reason, presence: true

  def ban_user
    user.update(banned: true) if user.notices_count == 5
  end
end
