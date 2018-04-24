Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'products#index'

  resources :orders
  resources :products
  resources :orderitems
  resources :merchants do
    resources :products, except: [:show]
  end

  get '/viewcart', to: 'order#viewcart', as: 'viewcart'

  post '/products/categories/new', to: 'products#new_category', as: 'new_category'
  get '/:category', to: 'products#index', as: 'category'

  get "/auth/:provider/callback", to: "sessions#create", as: 'auth_callback_path'
  delete "/logout", to: "sessions#destroy", as: "logout"

end
