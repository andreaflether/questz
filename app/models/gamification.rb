# frozen_string_literal: true

class Gamification
  def initialize(user)
    @user = user
  end

  def exp_to_next_level
    (((@user.level + 1) * 4)**2)
  end

  def grant_experience_to_user(exp)
    @user.experience += exp
    @user.save!
    verify_level_up
  end

  def verify_level_up
    level_up if @user.experience >= exp_to_next_level
  end

  def level_up
    @user.level += 1
    @user.save!
  end
end
