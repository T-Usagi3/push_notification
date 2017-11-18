Rails.application.routes.draw do
  root to: 'home#index'

  resources :push_notifications, only: :create
end
