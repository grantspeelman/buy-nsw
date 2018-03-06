Rails.application.routes.draw do

  namespace :sellers do
    resources :applications
    get '/applications/:id/:step', to: 'applications#show', as: :application_step

    root to: 'base#index'
  end

  devise_for :users

  root to: 'static#index'
end
