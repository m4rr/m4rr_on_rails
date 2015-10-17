Rails.application.routes.draw do

  root 'welcome#index'
  get '@sync', to: 'welcome#sync'
  get 'mauth/sanmarco', to: 'mauth#sanmarco'
  resources :betum, controller: :mauth, path: 'mauth', only: [:index, :create, :show] # , as: 'mauth'
  
end
