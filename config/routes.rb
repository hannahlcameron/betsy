Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'products#index'

  resources :orderitems do
  end

  resources :products, only: [:index, :show]
  get '/:category', to: 'products#index', as: 'category'

  resources :merchants do
    resources :products, except: [:show]
  end

end
