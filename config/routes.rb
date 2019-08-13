Rails.application.routes.draw do
  root 'welcome#index'
  resources :bookings, only: [:index]
  resources :users do
      collection do
        post '/login', to: 'users#login'
      end
      resources :bookings, only: [:create]

  end
  resources :sessions, only:[:index, :show]
  # resources :bookings, only:[:index, :create]
  resources :subscriptions
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
