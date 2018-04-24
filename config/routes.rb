Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'products#index'

  resources :orders

  resources :merchants, except: [:new, :create] do
    resources :orders, only: [:index]
    resources :products, except: [:show]
    get '/manage_products', to: 'merchants#manage_products', as: 'manage_products'
  end

  resources :orderitems, only: [:create, :update, :destroy]

  resources :reviews, only: [:create]

  resources :categories, only: [:create]

  resources :products, only: [:index, :show]


  get '/:category', to: 'products#index', as: 'category'

  post '/products/categories/new', to: 'products#new_category', as: 'new_category'

  get '/:id/viewcart', to: 'orders#viewcart', as: 'viewcart'

  get "/auth/:provider/callback", to: "sessions#create", as: 'auth_callback'

  delete "/logout", to: "sessions#destroy", as: "logout"

end
