Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/instagram/authorize_app', to: 'front/instagram#log_in', as: :instagram_authorize_app
  get '/instagram/authorize', to: 'front/instagram#authorize', as: :instagram_authorize
  get '/instagram/callback', to: 'front/instagram#callback', as: :instagram_callback

  root 'front/tags#index'

  scope module: 'front' do
    resources :tags, only: %i[index show create]
  end
end
