# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  content    :text
#  status     :integer          default("unanswered")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_questions_on_user_id  (user_id)
#
require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should define_enum_for(:status).
      with_values([:unanswered, :answered, :closed]) }

  it { expect(subject).to belong_to(:user) }

  describe '#content' do 
    it { expect(subject).to validate_length_of(:content).is_at_least(10).is_at_most(200) }
  end
end
