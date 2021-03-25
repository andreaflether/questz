# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  avatar                 :string
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  name                   :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  username               :string           default(""), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  acts_as_voter
  acts_as_follower
  
  mount_uploader :avatar, AvatarUploader
  attr_accessor :avatar_cache

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50, allow_blank: true }
  validates :username, presence: true,
                       uniqueness: { case_sensitive: false, allow_blank: true },
                       format: { with: /\A^[A-Za-z0-9_]+\Z/, allow_blank: true },
                       length: { minimum: 4, maximum: 20, allow_blank: true }

  validate :username_has_at_least_one_letter, unless: -> { username.blank? }

  def username_has_at_least_one_letter
    unless username.count('a-zA-Z').positive?
      errors.add(:username, I18n.t('activerecord.errors.models.user.attributes.username.numeric_only'))
    end
  end

  def max_filesize_for_avatar
    avatar.size_range.last / (1024.0 * 1024.0).to_i
  end
end
