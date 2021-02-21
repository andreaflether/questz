# frozen_string_literal: true

# == Schema Information
#
# Table name: answers
#
#  id         :integer          not null, primary key
#  body       :text             default(""), not null
#  chosen     :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe '#title' do
    it { expect(subject).to validate_length_of(:body).is_at_least(15).is_at_most(30000) }
    it { expect(subject).to validate_presence_of(:body) }
  end
end
