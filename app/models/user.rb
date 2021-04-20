# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  answers_count          :integer          default(0)
#  avatar                 :string
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  level                  :integer          default(1), not null
#  name                   :string           default(""), not null
#  questions_count        :integer          default(0)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  slug                   :string
#  username               :string           default(""), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_slug                  (slug) UNIQUE
#
class User < ApplicationRecord
  acts_as_voter
  acts_as_follower

  include Honor

  extend FriendlyId
  friendly_id :username, use: %i[slugged finders]

  include PublicActivity::Model
  tracked only: %i[create], owner: ->(_controller, model) { model }

  mount_uploader :avatar, AvatarUploader
  attr_accessor :avatar_cache

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :reports, dependent: :destroy

  before_destroy :remove_activity

  validates :name, presence: true, length: { maximum: 50, allow_blank: true }
  validates :username, presence: true,
                       uniqueness: { case_sensitive: false, allow_blank: true },
                       format: { with: /\A^[A-Za-z0-9_]+\Z/, allow_blank: true },
                       length: { minimum: 4, maximum: 20, allow_blank: true }

  validate :username_has_at_least_one_letter, unless: -> { username.blank? }

  def should_generate_new_friendly_id?
    username_changed? || super
  end

  def username_has_at_least_one_letter
    unless username.count('a-zA-Z').positive?
      errors.add(:username, I18n.t('activerecord.errors.models.user.attributes.username.numeric_only'))
    end
  end

  def remove_activity
    activity = PublicActivity::Activity.find_by(trackable_id: id)
    activity.destroy if activity.present?
    true
  end

  def has_privilege_to_create_tag?
    points_total >= 500
  end

  def exp_to_next_level
    ((level * 4)**2)..(((level + 1) * 4)**2)
  end

  def level_up
    update(level: level + 1)
    create_activity(key: 'user.level_up', owner: self, parameters: { level: level })
  end

  def level_down
    update(level: level - 1)
    create_activity(key: 'user.level_down', owner: self, parameters: { level: level })
  end

  def max_filesize_for_avatar
    avatar.size_range.last / (1024.0 * 1024.0).to_i
  end

  def solved_questions
    answers.where(chosen: true).count
  end

  def check_for_reports(reportable)
    reports.where(reportable: reportable)
  end

  scope :top_users, lambda {
    Honor::Scorecard.leaderboard(User.all.map(&:id), rank_by: 'lifetime', sort_direction: 'desc')
                    .includes(:user)
  }

  scope :top_answerers_in_tag, lambda { |tag|
    joins(:answers)
      .where(answers: { chosen: true, question_id: Question.tagged_with(tag) })
      .select(:id, :username, :experience, :slug, 'COUNT(answers.id) AS chosen_answers_count')
      .group(:username)
      .order(chosen_answers_count: :desc)
  }
end
