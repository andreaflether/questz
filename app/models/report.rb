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

  ransacker :status, formatter: proc { |v| statuses[v] }
  ransacker :reason, formatter: proc { |v| reasons[v] }

  before_create :generate_report_number

  validates :reason, presence: true
  validates :user_id, uniqueness: { scope: %i[reportable_type reportable_id] }
  validates :mod_attention_details, length: { in: 10..255, if: -> { mod_intervention? } },
                                    absence: { if: -> { !mod_intervention? } }
  validates :duplicate_id, presence: { if: -> { duplicate? } },
                           absence: { if: -> { !duplicate? } }
  validates :assigned_user_id, presence: { if: -> { status_changed?(to: 'ongoing') } }
  validates :solved_by_id, presence: { if: -> { was_solved_or_closed? } }
  validate :assigned_to_user, if: -> { assigned_user_id_changed?(from: nil) }
  validate :solved_info, if: -> { was_solved_or_closed? }

  belongs_to :duplicate, class_name: 'Question', optional: true
  belongs_to :assigned_user, class_name: 'User', optional: true
  belongs_to :solved_by, class_name: 'User', optional: true

  def to_param
    number
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[assigned_user_id number reason reportable_type user_id status]
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
    self.number = Date.today.strftime('%Y%m%d') + reportable_type_abbr + next_report_number
  end

  def return_to_pending
    self.status = 'pending'
  end

  def assigned_to_user
    self.status = 'ongoing'
  end

  def solved_info
    self.assigned_user = nil
    self.solved_at = DateTime.now
  end

  def was_solved_or_closed?
    status_changed?(to: 'closed') || status_changed?(to: 'solved')
  end
end
