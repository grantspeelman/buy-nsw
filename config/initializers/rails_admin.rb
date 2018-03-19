RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  # == Gravatar integration ==
  # To disable Gravatar integration in Navigation Bar set to false
  config.show_gravatar = false

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    # new
    export do
      only ['Seller', 'User', 'SellerApplication']
    end
    bulk_delete do
      only ['Seller', 'User', 'SellerApplication']
    end
    show do
      only ['Seller', 'User', 'SellerApplication']
    end
    edit do
      only ['Seller', 'User', 'SellerApplication']
    end
    delete do
      only ['Seller', 'User', 'SellerApplication']
    end
    # show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
