# == Schema Information
#
# Table name: bans
#
#  id                                      :bigint           not null, primary key
#  acknowledged_ban                        :boolean          default(FALSE)
#  ban_type(0: Temporary, 1: Permanent)    :integer          default(0), not null
#  ends_at                                 :datetime
#  reason                                  :text             not null
#  revoked_at                              :datetime
#  status(0: Active, 1: Ended, 2: Revoked) :integer          not null
#  total_notices                           :integer
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
  include ActionView::Helpers::DateHelper

  belongs_to :user
  belongs_to :revoker, class_name: 'User', optional: true
  belongs_to :ban_author, class_name: 'User', optional: true

  validates :unban_reason, :revoker_id, presence: true, if: -> { status_changed?(to: :revoked) }
  validates :reason, :status, presence: true
  validates :acknowledged_ban, presence: true

  before_validation :set_ban_message, on: :create

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

  def additional_info_mapping
    case total_notices
    when 3 then :temporary_ban_warning
    when 6 then :permanent_ban_warning
    when 8.. then :permanent_ban_notice
    end
  end

  def set_ban_message
    return if reason.present?

    duration = case ban_type
               when 'temporary'
                 "for #{distance_of_time_in_words(Time.current, ends_at)}"
               when 'permanent'
                 'permanently'
               end

    self.reason = I18n.t('messages.bans.automatic_ban',
                         duration: duration,
                         additional_info: I18n.t("messages.bans.#{additional_info_mapping}"))
  end
end
