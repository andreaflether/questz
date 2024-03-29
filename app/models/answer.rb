# frozen_string_literal: true

# == Schema Information
#
# Table name: answers
#
#  id          :bigint           not null, primary key
#  body        :text             default(""), not null
#  chosen      :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  question_id :bigint
#  user_id     :bigint
#
# Indexes
#
#  index_answers_on_question_id  (question_id)
#  index_answers_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (question_id => questions.id)
#  fk_rails_...  (user_id => users.id)
#
class Answer < ApplicationRecord
  acts_as_votable

  include PublicActivity::Model
  tracked only: %i[create destroy], owner: ->(_controller, model) { model.user }

  EXP_FOR_ACTION = {
    accept: I18n.t('honor.exp.answer.accept'),
    choose: I18n.t('honor.exp.answer.choose'),
    create: I18n.t('honor.exp.answer.create'),
    destroy: I18n.t('honor.exp.answer.destroy').abs
  }.freeze

  after_create lambda {
    Point.give_to(
      user.id,
      EXP_FOR_ACTION[:create],
      I18n.t('honor.message.answer.create', points: EXP_FOR_ACTION[:create]),
      'answer.create'
    )
  }
  after_destroy lambda {
    Point.take_from(
      user.id,
      EXP_FOR_ACTION[:destroy],
      I18n.t('honor.message.answer.destroy', points: EXP_FOR_ACTION[:destroy]),
      'answer.destroy'
    )
  }

  validate :cannot_receive_answers, on: :create, unless: -> { question.answered? }

  attribute :has_restricted_word, :boolean, default: false
  attribute :has_link, :boolean, default: false

  belongs_to :question, counter_cache: true
  belongs_to :user, counter_cache: true
  has_many :reports, as: :reportable

  validate :can_be_marked_as_solved?, if: -> { chosen_changed?(from: false, to: true) }
  validate :set_question_as_solved, if: -> { chosen_changed?(from: false, to: true) }
  validates :body, length: { in: 15..30_000, allow_blank: true }, presence: true

  acts_as_notifiable :users,
                     targets: ->(answer, _key) { [answer.question.user] },
                     group: :question, notifier: :user,
                     notifiable_path: :question_notifiable_path,
                     dependent_notifications: :update_group_and_delete_all

  acts_as_notifiable :answer_owners,
                     targets: ->(answer, _key) { [answer.user] },
                     notifiable_path: :question_notifiable_path,
                     dependent_notifications: :update_group_and_delete_all

  def question_notifiable_path
    question_path(question, anchor: "answer_#{id}")
  end

  def set_question_as_solved
    question.answered!
    # The user who accepted the answer
    create_activity(:choose, owner: question.user, key: 'answer.choose')
    Point.give_to(
      question.user.id,
      EXP_FOR_ACTION[:choose],
      I18n.t('honor.message.answer.choose', points: EXP_FOR_ACTION[:choose]),
      'answer.choose'
    )
    # The user who posted the answer
    create_activity(:choose, owner: user, key: 'answer.accept')
    Point.give_to(
      user.id,
      EXP_FOR_ACTION[:accept],
      I18n.t('honor.message.answer.accept', points: EXP_FOR_ACTION[:accept]),
      'answer.accept'
    )
  end

  def cannot_receive_answers
    errors.add(:base, I18n.t('messages.errors.answers.question_closed')) if question.closed?
  end

  def can_be_marked_as_solved?
    errors.add(:base, I18n.t('messages.errors.answers.already_answered')) if question.answered?
  end
end
