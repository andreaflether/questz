# frozen_string_literal: true

# == Schema Information
#
# Table name: reports
#
#  id                     :integer          not null, primary key
#  closing_notice_details :text
#  mod_attention_details  :string
#  number                 :string
#  reason                 :integer
#  reportable_type        :string
#  status                 :integer          default("pending")
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  assigned_user_id       :integer
#  duplicate_id           :integer
#  reportable_id          :integer
#  user_id                :integer
#
# Indexes
#
#  index_reports_on_reportable_type_and_reportable_id  (reportable_type,reportable_id)
#
class Report < ApplicationRecord
  belongs_to :reportable, polymorphic: true
  belongs_to :user
  has_many :notices

  enum reason: {
    spam: 1,
    unfriendly: 2,
    abusive: 3,
    needs_details: 4,
    needs_focus: 5,
    not_an_answer: 6,
    no_longer_needed: 7,
    duplicate: 8,
    mod_intervention: 9
  }

  enum status: {
    pending: 1,
    ongoing: 2,
    closed: 3,
    solved: 4
  }

  before_create :generate_report_number

  validates :reason, presence: true
  validates :user_id, uniqueness: { scope: %i[reportable_type reportable_id] }
  validates :mod_attention_details, length: { in: 10..255, if: -> { mod_intervention? } },
                                    absence: { if: -> { !mod_intervention? } }
  validates :duplicate_id, presence: { if: -> { duplicate? } },
                           absence: { if: -> { !duplicate? } }
  validates :assigned_user_id, presence: { if: -> { ongoing? } }

  belongs_to :duplicate, class_name: 'Question', optional: true
  belongs_to :assigned_user, class_name: 'User', optional: true

  def to_param
    number
  end

  def self.question_reasons
    reasons_i18n.except :not_an_answer, :no_longer_needed
  end

  def self.answer_reasons
    reasons_i18n.except :needs_details, :needs_focus, :duplicate, :no_longer_needed
  end

  def reportable_type_abbr
    reportable_type.slice(0)
  end

  def last_report_number
    Report.where(
      created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, 
      reportable_type: reportable_type
    ).count
  end

  def next_report_number
    next_number = last_report_number + 1
    next_number.to_s.rjust(5, '0')
  end

  def generate_report_number
    self.number = Date.today.strftime("%Y%m%d") + reportable_type_abbr + next_report_number
  end
end
