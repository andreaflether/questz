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
class Answer < ApplicationRecord
  acts_as_votable

  include PublicActivity::Model
  tracked only: [:create], owner: ->(controller, model) { model.user }

  EXP_FOR_ACTION = {
    create: 16,
    chosen: 24,
    destroy: -16
  }.freeze

  after_create -> { set_gamification('create') }
  after_destroy -> { set_gamification('destroy') }
  before_destroy :remove_activity

  belongs_to :question, counter_cache: true
  belongs_to :user, counter_cache: true

  validate :set_question_as_solved, if: -> { chosen_changed?(from: false, to: true) }
  validates :body, length: { in: 15..30_000, allow_blank: true }, presence: true

  def set_question_as_solved
    question.answered!
    set_gamification('chosen')
  end

  def set_gamification(action)
    gamification = Gamification.new(user)
    gamification.grant_experience_to_user(EXP_FOR_ACTION[action.to_sym])
  end

  def remove_activity
    activity = PublicActivity::Activity.find_by(trackable_id: id)
    activity.destroy if activity.present?
    true
  end
end
