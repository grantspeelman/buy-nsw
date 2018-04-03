Rails.application.routes.draw do

  namespace :sellers do
    resources :applications, only: [:new, :show, :update] do
      resources :products, controller: 'applications/products'
    end
    get '/applications/:id/:step', to: 'applications#show', as: :application_step

    resources :profiles, only: :show
    get '/search', to: 'search#search', as: :search
  end

  devise_for :users

  get '/cloud', to: 'static#cloud', as: :cloud
  get '/cloud/:section', to: 'pathways/search#search', as: :pathway_search
  get '/cloud/:section/products/:id', to: 'pathways/products#show', as: :pathway_product

  namespace :ops do
    resources :seller_applications, path: 'seller-applications' do
      member do
        get :assign
        get :seller_details
        get :documents

        patch :update_assign, path: 'assign'
        patch :decide
      end
    end

    root to: 'root#index'
  end

  root to: 'static#index'
end
