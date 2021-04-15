# frozen_string_literal: true

# == Schema Information
#
# Table name: questions
#
#  id                 :integer          not null, primary key
#  answers_count      :integer          default(0)
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

  include PublicActivity::Model
  tracked only: %i[create destroy], owner: ->(_controller, model) { model.user }

  is_impressionable counter_cache: true

  enum status: {
    unanswered: 0,
    answered: 1,
    closed: 2
  }

  EXP_FOR_ACTION = {
    create: I18n.t('honor.exp.question.create'),
    destroy: I18n.t('honor.exp.question.destroy').abs
  }.freeze

  has_many :answers, dependent: :destroy
  belongs_to :user, counter_cache: true

  after_create lambda {
    Point.give_to(
      user.id,
      EXP_FOR_ACTION[:create],
      I18n.t('honor.message.question.create', points: EXP_FOR_ACTION[:create]),
      'question.create'
    )
  }
  after_destroy lambda {
    Point.take_from(
      user.id,
      EXP_FOR_ACTION[:destroy],
      I18n.t('honor.message.question.destroy', points: EXP_FOR_ACTION[:destroy]),
      'question.destroy'
    )
  }

  validates :title, length: { in: 15..150, allow_blank: true }, presence: true
  validates :body, length: { in: 15..20_000, allow_blank: true }, presence: true
  validate :tag_list_count
  validate :check_for_answers, on: :destroy

  def tag_list_count
    errors.add(:tag_list, 'Please select at least 1 tag to identify your question') if tag_list.count < 1
    errors.add(:tag_list, 'Please enter no more than 5 tags.') if tag_list.count > 5
  end

  def has_answers?
    answers_count.positive?
  end

  def check_for_answers
    errors.add(:base, 'You cannot delete this question because it already has answers.') if has_answers?
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

  scope :not_closed, lambda {
    where.not(status: :closed)
  }

  scope :user_interacted, lambda { |user|
    where(id: user.answers.pluck(:question_id)).or(user.questions).distinct
  }
end
