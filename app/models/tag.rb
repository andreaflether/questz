# frozen_string_literal: true

# == Schema Information
#
# Table name: tags
#
#  id             :integer          not null, primary key
#  name           :string
#  taggings_count :integer          default(0)
#  created_at     :datetime
#  updated_at     :datetime
#
# Indexes
#
#  index_tags_on_name  (name) UNIQUE
#

class Tag < ActsAsTaggableOn::Tag
  acts_as_followable

  include PublicActivity::Model

  before_destroy :remove_activity

  def remove_activity
    activity = PublicActivity::Activity.find_by(trackable_id: id)
    activity.destroy if activity.present?
    true
  end

  scope :alphabetic_order, lambda {
    order(name: :asc)
  }

  scope :newest, lambda {
    order(created_at: :desc)
  }
end
