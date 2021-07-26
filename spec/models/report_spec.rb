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
#  status                 :integer          default("opened")
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
require 'rails_helper'

RSpec.describe Report, type: :model do
  let(:duplicated) { create(:report, :duplicated_question, reason: 'duplicate') }
  let(:needs_mod_intervention) { create(:report, :needs_mod_intervention, reason: 'mod_intervention') }

  it { expect(subject).to belong_to(:reportable) }
  it { expect(subject).to belong_to(:user) }
  it { expect(subject).to belong_to(:duplicate).class_name('Question').optional }

  it {
    expect(subject).to define_enum_for(:reason)
      .with_values(
        spam: 1, unfriendly: 2, abusive: 3,
        needs_details: 4, needs_focus: 5, not_an_answer: 6,
        no_longer_needed: 7, duplicate: 8, mod_intervention: 9
      )
  }

  it { expect(subject).to validate_presence_of(:reason) }

  it { expect(duplicated).to validate_presence_of(:duplicate_id) }
  it { expect(subject).to validate_absence_of(:duplicate_id) }

  it {
    expect(needs_mod_intervention).to validate_length_of(:mod_attention_details)
      .is_at_least(10).is_at_most(255)
  }

  it { expect(subject).to validate_absence_of(:mod_attention_details) }

  it { expect(described_class.question_reasons).not_to have_key(%i[not_an_answer no_longer_needed]) }

  it {
    expect(described_class.answer_reasons).not_to have_key(
      %i[needs_details needs_focus duplicate no_longer_needed]
    )
  }
end
