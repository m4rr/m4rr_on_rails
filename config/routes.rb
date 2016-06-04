Rails.application.routes.draw do
  root 'welcome#index'

  # Error 451
  get '/451', to: redirect('/404', status: 451)

  # CV
  @cv_pdf_url ||= '/marat-saytakov-cv.pdf'
  get '/marat-saytakov-resume.pdf', to: redirect(@cv_pdf_url)
  get '/cv.pdf', to: redirect(@cv_pdf_url)
  get '/cv', to: redirect(@cv_pdf_url)

  # Auth-based sync map data with Tripster
  get '@sync', to: 'welcome#sync'

  # Mauth
  get 'mauth', to: 'mauth#index'
  get 'mauth/privacy-policy', to: 'mauth#privacy_policy'
end
