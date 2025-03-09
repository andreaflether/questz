# == Schema Information
#
# Table name: bans
#
#  id                                      :bigint           not null, primary key
#  ban_type(0: Temporary, 1: Permanent)    :integer          default(0), not null
#  ends_at                                 :datetime
#  reason                                  :text             not null
#  revoked_at                              :datetime
#  status(0: Active, 1: Ended, 2: Revoked) :integer          not null
#  unban_reason                            :text
#  created_at                              :datetime         not null
#  updated_at                              :datetime         not null
#  ban_author_id                           :bigint
#  revoker_id                              :bigint
#  user_id                                 :bigint           not null
#
# Indexes
#
#  index_bans_on_ban_author_id  (ban_author_id)
#  index_bans_on_revoked_at     (revoked_at)
#  index_bans_on_revoker_id     (revoker_id)
#  index_bans_on_status         (status)
#  index_bans_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (ban_author_id => users.id)
#  fk_rails_...  (revoker_id => users.id)
#  fk_rails_...  (user_id => users.id)
#
class Ban < ApplicationRecord
  belongs_to :user
  belongs_to :revoker, class_name: 'User', optional: true
  belongs_to :ban_author, class_name: 'User', optional: true

  validates :unban_reason, :revoker_id, if: -> { status_changed?(to: :revoked) }
  validates :reason, :status, presence: true

  before_create :set_ban_message

  attribute :strikes, :integer

  FIRST_BAN = 7.days
  SECOND_BAN = 30.days

  enum status: {
    active: 0,
    ended: 1,
    revoked: 2
  }

  enum ban_type: {
    temporary: 0,
    permanent: 1
  }

  def set_ban_message
    duration = case ban.ban_type
               when :temporary
                 "for #{time_ago_in_words(ban.ends_at)}"
               when :permanent
                 'permanently'
               else
                 'for an unspecified period'
               end

    I18n.t('messages.bans.reason', duration: duration)
  end
end
