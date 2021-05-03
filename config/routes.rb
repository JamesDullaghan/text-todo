Rails.application.routes.draw do

  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_up: 'register',
    sign_out: 'logout',
  }

  # Matches the Signed Request
  resources :text_messages, only: [:create]

  devise_scope :user do
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end

    authenticate do
      root 'dashboard#index'
    end

    get 'dashboard' => 'dashboard#index', as: :dashboard
    resources :todo_lists, only: [:create]
  end
end