# frozen_string_literal: true

module ProfilesHelper
  def current_xp_to_pc(user)
    (100 * user.points_total) / user.exp_to_next_level.last
  end
end
