Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :orderitems
  resources :products
  resources :order
  get 'order/viewcart', to: 'orders#viewcart', as: viewcart

end
