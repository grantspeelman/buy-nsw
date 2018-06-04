Rails.application.routes.draw do

  devise_for :users,  path: '',
                      path_names: {
                        sign_in: 'sign-in',
                      },
                      controllers: {
                        registrations: 'users/registrations',
                        confirmations: 'users/confirmations',
                      },
                      skip: [
                        :registrations,
                      ],
                      skip_helpers: true

  devise_scope :user do
    get '/register', to: redirect('/sign-in'), as: :register_without_type
    get '/register/:type', to: 'users/registrations#new', as: :registration
    post '/register/:type', to: 'users/registrations#create'
    get '/register/:type/confirm', to: 'users/registrations#confirm', as: :registration_confirm

    get '/account', to: 'users/registrations#edit', as: :edit_account
    put '/account', to: 'users/registrations#update', as: :account
  end

  namespace :sellers do
    resources :applications, only: [:new, :create, :show, :update], controller: 'applications/root' do
      member do
        get :submit
        post :submit, to: 'applications/root#do_submit'
      end

      resources :products, controller: 'applications/products' do
        member do
          post :clone
        end
      end
      get '/products/:id/:step', to: 'applications/products#edit', as: :product_step
      patch '/products/:id/:step', to: 'applications/products#update'

      resources :invitations, controller: 'applications/invitations', only: [:index, :new, :create] do
        collection do
          get :accept
          patch '/accept', to: 'applications/invitations#update_accept', as: :update_accept
        end
      end
    end
    get '/applications/:id/:step', to: 'applications/steps#show', as: :application_step
    patch '/applications/:id/:step', to: 'applications/steps#update'

    resources :profiles, only: :show
    resources :waitlist_invitations, path: 'waitlist', only: :show do
      patch :accept, on: :member
    end

    get '/search', to: 'search#search', as: :search
    get '/dashboard', to: 'dashboard#show', as: :dashboard
  end

  namespace :buyers do
    resources :applications
    get '/applications/:id/manager-approve', to: 'applications#manager_approve', as: :manager_approve_application
    get '/applications/:id/:step', to: 'applications#show', as: :application_step
  end

  get '/cloud', to: 'static#cloud', as: :cloud
  get '/cloud/:section', to: 'pathways/search#search', as: :pathway_search
  get '/cloud/:section/products/:id', to: 'pathways/products#show', as: :pathway_product

  namespace :ops do
    resources :buyers do
      member do
        get :details
        post :deactivate
      end
    end

    resources :buyer_applications, path: 'buyer-applications' do
      member do
        get :buyer_details

        patch :assign
        patch :decide
        post :notes
      end
    end

    resources :seller_applications, path: 'seller-applications' do
      member do
        get :seller_details
        get :documents

        patch :assign
        patch :decide
        post :notes
      end

      resources :products, only: :show, controller: 'seller_applications/products'
    end

    resources :waiting_sellers, path: 'waiting-sellers' do
      collection do
        post :upload, to: 'waiting_sellers#upload'
        get :invite, to: 'waiting_sellers#invite'
        post :invite, to: 'waiting_sellers#do_invite'
      end
    end

    resources :problem_reports, path: 'problem-reports', only: [:index, :show] do
      member do
        post :resolve
        put :tag
      end
    end

    root to: 'root#index'
  end

  namespace :feedback do
    resources :problem_reports, path: 'problem-reports', only: [:new, :create]
  end

  get '/contact', to: 'static#contact'
  get '/privacy', to: 'static#privacy'
  get '/terms-of-use', to: 'static#terms_of_use'
  get '/accessibility', to: 'static#accessibility'
  get '/core-terms', to: 'static#core_terms'
  get '/guides/seller', to: 'static#seller_guide'
  get '/guides/buyer', to: 'static#buyer_guide'
  get '/license', to: 'static#license'
  # Health check page for load balancer - never use basic auth
  get '/health', to: 'static#health'

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  root to: redirect('/cloud')
end
