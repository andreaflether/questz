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
class Report < ApplicationRecord
  belongs_to :reportable, polymorphic: true
  belongs_to :user

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

  before_create :generate_report_number

  validates :reason, presence: true
  validates :user_id, uniqueness: { scope: %i[reportable_type reportable_id] }
  validates :mod_attention_details, length: { in: 10..255, if: -> { mod_intervention? } },
                                    absence: { if: -> { !mod_intervention? } }
  validates :duplicate_id, presence: { if: -> { duplicate? } },
                           absence: { if: -> { !duplicate? } }
  belongs_to :duplicate, class_name: 'Question', optional: true

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
    self.report_number = Date.today.strftime("%Y%m%d") + reportable_type_abbr + next_report_number
  end
end
