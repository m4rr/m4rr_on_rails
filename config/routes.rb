Rails.application.routes.draw do

  get  'mauth' => 'mauth#index'
  post 'mauth' => 'mauth#create'

  get '@sync' => 'welcome#sync'

  root 'welcome#index'

end
