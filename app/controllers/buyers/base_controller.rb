class Buyers::BaseController < ApplicationController

private
  def validate_active_buyer!
    unless current_user.present? && current_user.is_active_buyer?
      raise NotAuthorized
    end
  end
end
