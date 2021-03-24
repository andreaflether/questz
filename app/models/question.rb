# frozen_string_literal: true

# == Schema Information
#
# Table name: questions
#
#  id                 :integer          not null, primary key
#  answers_count      :integer
#  body               :text             default(""), not null
#  cached_votes_down  :integer          default(0)
#  cached_votes_score :integer          default(0)
#  cached_votes_total :integer          default(0)
#  cached_votes_up    :integer          default(0)
#  impressions_count  :integer          default(0)
#  status             :integer          default("unanswered")
#  title              :string           default(""), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :integer
#
# Indexes
#
#  index_questions_on_user_id  (user_id)
#
class Question < ApplicationRecord
  acts_as_votable
  acts_as_taggable_on :tags

  is_impressionable counter_cache: true

  enum status: {
    unanswered: 0,
    answered: 1,
    closed: 2
  }

  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title, length: { in: 15..150, allow_blank: true }, presence: true
  validates :body, length: { in: 15..20_000, allow_blank: true }, presence: true

  scope :filter_by_tag, lambda { |tag|
    tagged_with(tag)
  }
end
