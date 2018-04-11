Rails.application.routes.draw do

  namespace :sellers do
    resources :applications, only: [:new, :show, :update] do
      resources :products, controller: 'applications/products'
    end
    get '/applications/:id/:step', to: 'applications#show', as: :application_step

    resources :profiles, only: :show
    get '/search', to: 'search#search', as: :search
  end

  namespace :buyers do
    resources :applications
    get '/applications/:id/manager-approve', to: 'applications#manager_approve', as: :manager_approve_application
    get '/applications/:id/:step', to: 'applications#show', as: :application_step
  end

  devise_for :users

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
