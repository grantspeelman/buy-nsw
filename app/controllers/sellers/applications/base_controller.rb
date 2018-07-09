class Sellers::Applications::BaseController < Sellers::BaseController
  before_action :authenticate_user!
  layout '../sellers/applications/shared/_layout'

  helper Sellers::ApplicationsHelper

private
  def _run_options(options)
    options.merge( 'config.current_user' => current_user )
  end

  def seller_version
    @seller_version ||= current_user.seller_versions.created.find(params[:id])
  end
  helper_method :seller_version

  # NOTE: This is deprecated and `seller_version` should be used instead.
  def application
    seller_version
  end
  helper_method :application
end
