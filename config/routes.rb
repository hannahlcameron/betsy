Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :orderitems do
  end

  resources :products, only: [:index, :show]

  resources :merchants do
    resources :products
  end

end
