class StaticController < ApplicationController
  # We don't want the health check page ever to have basic auth in front of it
  skip_before_action :authenticate!, only: [:health]

  def index
  end

  def contact
  end

  def join_mailing_list
  end

  def privacy
  end

  def terms_of_use
  end

  def accessibility
  end

  def buyer_guide
  end

  def seller_guide
  end

  def license
  end

  def govdc
  end

  def health
    render plain: 'Yes, the application is running'
  end
end
