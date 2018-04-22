Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :orderitems
  resources :products
  resources :merchants do
    resources :products, only [:index, :new]
  resources :order
  get '/viewcart', to: 'order#viewcart', as: 'viewcart'

end
