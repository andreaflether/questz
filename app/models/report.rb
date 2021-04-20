# frozen_string_literal: true

# == Schema Information
#
# Table name: reports
#
#  id                    :integer          not null, primary key
#  mod_attention_details :string
#  reason                :integer
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
    duplicate: 6,
    not_an_answer: 7,
    no_longer_needed: 8,
    mod_intervention: 9
  }

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
end
