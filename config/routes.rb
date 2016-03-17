Rails.application.routes.draw do

  root "welcome#index"
  get '/marat-saytakov-resume.pdf', to: redirect('/marat-saytakov-cv.pdf')
  get '/cv.pdf', to: redirect('/marat-saytakov-cv.pdf')
  get '/cv', to: redirect('/marat-saytakov-cv.pdf')
  get "@sync", to: "welcome#sync"

  get "mauth/sanmarco", to: "mauth#sanmarco"
  get "mauth/privacy-policy", to: "mauth#privacy_policy"
  resources :betum, controller: :mauth, path: 'mauth', only: [:index, :create, :show] # , as: "mauth"

  get '/relocated', to: 'relocated#hello'
end
