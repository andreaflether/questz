# frozen_string_literal: true

# == Schema Information
#
# Table name: points
#
#  id         :integer          not null, primary key
#  category   :string
#  message    :text
#  value      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_points_on_user_id  (user_id)
#
class Point < Honor::Point
  after_create :verify_user_experience

  def verify_user_experience
    if user.points_total >= user.exp_to_next_level.last
      user.level_up
    elsif user.exp_to_next_level.member?(user.points_total)
      nil
    else
      user.level_down
    end
  end
end
