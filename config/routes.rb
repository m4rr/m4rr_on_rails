Rails.application.routes.draw do

  # get  'mauth' => 'mauth#index'
  # post 'mauth' => 'mauth#create'

  resources :betum, controller: :mauth, path: 'mauth', only: [:index, :create] # , as: 'mauth'

  get '@sync' => 'welcome#sync'

  root 'welcome#index'

end
