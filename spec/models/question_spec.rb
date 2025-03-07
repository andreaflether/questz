# frozen_string_literal: true

# == Schema Information
#
# Table name: questions
#
#  id                                            :bigint           not null, primary key
#  answered_on                                   :datetime
#  answers_count                                 :integer          default(0)
#  body                                          :text             default(""), not null
#  cached_votes_down                             :integer          default(0)
#  cached_votes_score                            :integer          default(0)
#  cached_votes_total                            :integer          default(0)
#  cached_votes_up                               :integer          default(0)
#  closed_at                                     :datetime
#  closing_notice                                :integer
#  impressions_count                             :integer          default(0)
#  slug                                          :string
#  status(0: Unanswered, 1: Answered, 2: Closed) :integer          default("unanswered")
#  title                                         :string           default(""), not null
#  created_at                                    :datetime         not null
#  updated_at                                    :datetime         not null
#  duplicate_id                                  :integer
#  user_id                                       :bigint
#
# Indexes
#
#  index_questions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
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
    it { expect(subject).to validate_length_of(:title).is_at_least(15).is_at_most(150) }
    it { expect(subject).to validate_presence_of(:title) }
  end

  describe '#body' do
    it { expect(subject).to validate_length_of(:body).is_at_least(15).is_at_most(20_000) }
    it { expect(subject).to validate_presence_of(:body) }
  end

  describe '.filter_by_tag' do
    let(:list_with_tag) { create_list(:question, 2, :with_test_tag) }

    before { create_list(:question, 3) }

    it { expect(described_class.filter_by_tag('test')).to match_array(list_with_tag) }
  end
end
