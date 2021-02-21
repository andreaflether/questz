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
class Answer < ApplicationRecord
  validates :body, length: { in: 15..30000, allow_blank: true }, presence: true
end
