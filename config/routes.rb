Rails.application.routes.draw do
  devise_for :users
  resources :text_messages, only: [:create]
end