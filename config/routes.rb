Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'products#index'

  resources :orders
  resources :merchants do
    resources :orders, only: [:index]
    resources :products, except: [:show]
  end

  get "/auth/:provider/callback", to: "sessions#create", as: "auth_callback"
  delete "/logout", to: "sessions#destroy", as: "logout"
  resources :orderitems do
  end

  resources :products, only: [:index, :show] do
  end
  post '/products/categories/new', to: 'products#new_category', as: 'new_category'
  get '/:category', to: 'products#index', as: 'category'
end
