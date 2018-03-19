Rails.application.routes.draw do

  namespace :sellers do
    resources :applications, only: [:new, :show, :update] do
      resources :products, controller: 'applications/products'
    end
    get '/applications/:id/:step', to: 'applications#show', as: :application_step

    resources :profiles, only: :show
    get '/search', to: 'search#search', as: :search

    root to: 'base#index'
  end

  devise_for :users

  get '/cloud', to: 'static#cloud', as: :cloud

  root to: 'static#index'
end
