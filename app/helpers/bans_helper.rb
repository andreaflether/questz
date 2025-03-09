module BansHelper
  def ban_message(ban_duration)
    "#{ban_duration / 1.day} day ban"
  end
end