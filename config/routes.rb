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
    resources :applications, only: [:new, :show, :update], controller: 'applications/root' do
      resources :products, controller: 'applications/products'
      member do
        post :submit
        
        get '/tailor', to: 'applications/tailor#show', as: :tailor
        get '/tailor/:step', to: 'applications/tailor#show', as: :tailor_step
        patch '/tailor', to: 'applications/tailor#update'

        get '/profile', to: 'applications/profile#show', as: :profile
        get '/profile/:step', to: 'applications/profile#show', as: :profile_step
        patch '/profile', to: 'applications/profile#update'

        get '/documents', to: 'applications/documents#show', as: :documents
        get '/documents/:step', to: 'applications/documents#show', as: :documents_step
        patch '/documents', to: 'applications/documents#update'

        get '/contacts', to: 'applications/contacts#show', as: :contacts
        get '/contacts/:step', to: 'applications/contacts#show', as: :contacts_step
        patch '/contacts', to: 'applications/contacts#update'

        get '/legals', to: 'applications/legals#show', as: :legals
        get '/legals/:step', to: 'applications/legals#show', as: :legals_step
        patch '/legals', to: 'applications/legals#update'
      end
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
