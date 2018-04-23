Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'products#index'

  resources :orders
  resources :orderitems do
  end

  resources :category, only: [:create]

  resources :merchants, except: [:new, :create] do
    resources :products, except: [:show]
  end

  resources :products, only: [:index, :show]
  get '/:category', to: 'products#index', as: 'category'



  get "/auth/:provider/callback", to: "sessions#create", as: 'auth_callback_path'
  delete "/logout", to: "sessions#destroy", as: "logout"

end
