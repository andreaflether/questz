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

  EXP_FOR_ACTION = {
    create: 16
  }.freeze

  belongs_to :user
  has_many :answers, dependent: :destroy

  after_create :set_gamification

  def set_gamification
    gamification = Gamification.new(user)
    gamification.grant_experience_to_user(EXP_FOR_ACTION[:create])
  end

  validates :title, length: { in: 15..150, allow_blank: true }, presence: true
  validates :body, length: { in: 15..20_000, allow_blank: true }, presence: true
  validate :tag_list_count

  def tag_list_count
    errors.add(:tag_list, 'Please select at least 1 tag to identify your question') if tag_list.count < 1
    errors.add(:tag_list, 'Please enter no more than 5 tags.') if tag_list.count > 5
  end

  scope :count_by_status_in_tag, lambda { |tag|
    tagged_with(tag).group(:status).count
  }

  scope :with_user_followed_tags, lambda { |user|
    tagged_with([user.all_following], any: true)
  }

  scope :newest, lambda {
    order(created_at: :desc)
  }

  scope :most_voted, lambda {
    order(cached_votes_up: :desc)
  }
end
