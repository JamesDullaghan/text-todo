Rails.application.routes.draw do
  resources :text_messages, only: [:create]
end