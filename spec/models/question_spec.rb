# frozen_string_literal: true

# == Schema Information
#
# Table name: questions
#
#  id            :integer          not null, primary key
#  answers_count :integer
#  content       :string           default(""), not null
#  status        :integer          default("unanswered")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer
#
# Indexes
#
#  index_questions_on_user_id  (user_id)
#
require 'rails_helper'

RSpec.describe Question, type: :model do
  it {
    expect(subject).to define_enum_for(:status)
      .with_values(%i[unanswered answered closed])
  }

  it { expect(subject).to belong_to(:user) }
  it { is_expected.to have_many(:answers).dependent(:destroy) }

  describe '#title' do
    it { expect(subject).to validate_length_of(:content).is_at_least(15).is_at_most(200) }
    it { expect(subject).to validate_presence_of(:content) }
  end
end
