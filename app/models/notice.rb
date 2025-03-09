# frozen_string_literal: true

# == Schema Information
#
# Table name: notices
#
#  id              :bigint           not null, primary key
#  details         :text             not null
#  noticeable_type :string
#  reason          :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  given_by_id     :integer          not null
#  noticeable_id   :bigint
#  user_id         :bigint
#
# Indexes
#
#  index_notices_on_noticeable  (noticeable_type,noticeable_id)
#  index_notices_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Notice < ApplicationRecord
  belongs_to :user, counter_cache: true
  belongs_to :given_by, class_name: 'User'
  belongs_to :noticeable, polymorphic: true

  enum reason: {
    spam: 1,
    unfriendly: 2,
    abusive: 3
  }

  after_create :check_for_bans
  validates :details, presence: true
  validates :reason, presence: true

  def check_for_bans
    return if user.notices_count < 3

    user.check_for_ban
  end
end
