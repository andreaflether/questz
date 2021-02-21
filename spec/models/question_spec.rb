# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  content    :text
#  status     :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should define_enum_for(:status).
      with_values([:not_answered, :answered, :closed]) }

  describe '#content' do 
    it { expect(subject).to validate_length_of(:content).is_at_least(10).is_at_most(200) }
  end
end
