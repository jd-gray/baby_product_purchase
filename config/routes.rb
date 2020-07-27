Rails.application.routes.draw do
  resources :products, only: [ :index, :show ]
  resources :orders, only: [ :new, :create, :show ] do
  collection do
      post "gift_order"
    end
  end
  
  root to: "products#index"
end
