# frozen_string_literal: true

# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  body        :text             default(""), not null
#  chosen      :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  question_id :integer
#  user_id     :integer
#
# Indexes
#
#  index_answers_on_question_id  (question_id)
#  index_answers_on_user_id      (user_id)
#
require 'rails_helper'

RSpec.describe Answer, type: :model do
  subject { create(:answer) }
  
  describe '#title' do
    it { expect(subject).to validate_length_of(:body).is_at_least(15).is_at_most(30_000) }
    it { expect(subject).to validate_presence_of(:body) }
  end

  it { expect(subject).to belong_to(:user) }
  it { expect(subject).to belong_to(:question).counter_cache(true) }
end
