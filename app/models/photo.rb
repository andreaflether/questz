# frozen_string_literal: true

# == Schema Information
#
# Table name: photos
#
#  id         :integer          not null, primary key
#  image      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Photo < ApplicationRecord
  mount_uploader :image, PhotoUploader
end
