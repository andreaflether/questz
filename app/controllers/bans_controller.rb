# BansController
class BansController < ApplicationController
  def acknowledge
    @ban = current_user.active_ban

    return unless request.post?

    @ban.assign_attributes(ban_params)

    if @ban.acknowledged_ban? && @ban.update(ban_params)
      redirect_to root_path, notice: 'You have acknowledged your ban.'
    else
      render :acknowledge, status: :unprocessable_entity, alert: 'Please acknowledge your ban.'
    end
  end

  private

  def ban_params
    params.require(:ban).permit(:acknowledged_ban)
  end
end
