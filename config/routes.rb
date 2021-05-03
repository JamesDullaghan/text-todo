Rails.application.routes.draw do
  root to: 'application#pong'

  resources :text_messages, only: [:create]
  get 'ping' => 'application#pong', as: :pong
end