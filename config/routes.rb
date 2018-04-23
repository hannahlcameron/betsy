Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'orders#index'

  resources :orders
  resources :products
  resources :orderitems
  resources :merchants do
    resources :products, only: [:index, :new]
  end
  resources :order
  get '/viewcart', to: 'order#viewcart', as: 'viewcart'

end
