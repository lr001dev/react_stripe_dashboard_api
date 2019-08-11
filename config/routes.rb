Rails.application.routes.draw do
  root 'welcome#index'
  resources :users do
   collection do
     post '/login', to: 'users#login'
   end 
  end
  resources :sessions, only:[:index]
  resources :subscriptions
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
