Rails.application.routes.draw do

  devise_for :users,  path: '',
                      path_names: {
                        sign_in: 'sign-in',
                      },
                      controllers: {
                        registrations: 'users/registrations',
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
  end

  namespace :sellers do
    resources :applications, only: [:new, :show, :update] do
      resources :products, controller: 'applications/products'
    end
    get '/applications/:id/:step', to: 'applications#show', as: :application_step

    resources :profiles, only: :show
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
      end
    end

    resources :seller_applications, path: 'seller-applications' do
      member do
        get :seller_details
        get :documents

        patch :assign
        patch :decide
      end
    end

    root to: 'root#index'
  end

  root to: 'static#index'
end
