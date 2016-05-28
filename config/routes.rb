Rails.application.routes.draw do
  root "welcome#index"

  get '/marat-saytakov-resume.pdf', to: redirect('/marat-saytakov-cv.pdf')
  get '/cv.pdf', to: redirect('/marat-saytakov-cv.pdf')
  get '/cv', to: redirect('/marat-saytakov-cv.pdf')
  get "@sync", to: "welcome#sync"

  get 'mauth', to: 'mauth#index'
  get "mauth/privacy-policy", to: "mauth#privacy_policy"
end
