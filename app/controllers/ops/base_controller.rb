class Ops::BaseController < ApplicationController
  before_action :authenticate_admin!
  
  layout 'ops'

private
  def authenticate_admin!
    unless current_user.is_admin?
      raise NotAuthorized
    end
  end

end
