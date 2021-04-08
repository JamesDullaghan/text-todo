Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'application#index'

  resources :text_messages, only: [:create]
  resources :voice_messages, only: [:create]
end