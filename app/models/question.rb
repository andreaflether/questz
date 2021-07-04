# frozen_string_literal: true

# == Schema Information
#
# Table name: questions
#
#  id                 :integer          not null, primary key
#  answered_on        :datetime
#  answers_count      :integer          default(0)
#  body               :text             default(""), not null
#  cached_votes_down  :integer          default(0)
#  cached_votes_score :integer          default(0)
#  cached_votes_total :integer          default(0)
#  cached_votes_up    :integer          default(0)
#  closed_at          :datetime
#  closing_notice     :integer
#  impressions_count  :integer          default(0)
#  slug               :string
#  status             :integer          default("unanswered")
#  title              :string           default(""), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  duplicate_id       :integer
#  user_id            :integer
#
# Indexes
#
#  index_questions_on_user_id  (user_id)
#
class Question < ApplicationRecord
  acts_as_votable
  acts_as_taggable_on :tags
  acts_as_notification_group printable_name: ->(question) { "question \"#{question.title}\"" }
  acts_as_url :title, url_attribute: :slug, sync_url: true, limit: 80

  include PublicActivity::Model
  tracked only: %i[create destroy], owner: ->(_controller, model) { model.user }

  is_impressionable counter_cache: true

  enum status: {
    unanswered: 0,
    answered: 1,
    closed: 2
  }

  enum closing_notice: {
    needs_details: 0,
    duplicate: 1,
    needs_focus: 2
  }

  attribute :reopen, :boolean

  EXP_FOR_ACTION = {
    create: I18n.t('honor.exp.question.create'),
    destroy: I18n.t('honor.exp.question.destroy').abs
  }.freeze

  MAX_TAGS_ALLOWED = 5
  MIN_TAGS_ALLOWED = 1

  has_many :answers, dependent: :destroy
  has_many :reports, as: :reportable
  belongs_to :user, counter_cache: true
  belongs_to :duplicate, class_name: 'Question', optional: true

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
  validates :closing_notice, presence: { if: -> { closed? } }
  validates :duplicate_id, presence: { if: -> { closed? && duplicate? } }

  validate :tag_list_count
  validate :check_for_answers, on: :destroy
  validate :reopen_question, if: -> { reopen_changed?(to: true) }
  validate :set_closed_at_timestamp, if: -> { status_changed?(to: 'closed') || closing_notice_changed? }
  validate :clean_closing_fields, if: -> { status_changed?(from: 'closed') }
  validate :set_answered_timestamp, if: -> { status_changed?(to: 'answered') }

  def to_param
    slug
  end
  
  def tag_list_count
    errors.add(:tag_list, I18n.t('errors.questions.tags.at_least_one')) if tag_list.count < MIN_TAGS_ALLOWED
    errors.add(:tag_list, I18n.t('errors.questions.tags.at_most_five')) if tag_list.count > MAX_TAGS_ALLOWED
  end

  def has_answers?
    answers_count.positive?
  end

  def check_for_answers
    errors.add(:base, I18n.t('errors.questions.has_answers')) if has_answers?
  end

  def set_closed_at_timestamp
    self.closed_at = DateTime.now
  end

  def reopen_question
    self.status = 'unanswered'
  end

  def clean_closing_fields
    self.closed_at = nil
    self.closing_notice = nil
  end

  def set_answered_timestamp
    self.answered_on = DateTime.now
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
