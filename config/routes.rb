Rails.application.routes.draw do
  devise_for :users
  root to: "restaurants#index"
  get "/restaurants/:id/kitchen", to: "restaurants#kitchen", as: "kitchen"
  get "/restaurants/:restaurant_id/users/:user_id/table_orders", to: "table_orders#server", as: "server"
  get "/order_items/:id/prepared", to: "order_items#prepared!", as: "prepared"
  get "/order_items/:id/served", to: "order_items#served!", as: "served"
  get "/table_customers/:id/ordered", to: "table_customers#ordered!", as: "ordered"
  # get "restaurants/:id/tables/:table_id/table_orders/:table_order_id/checkout", to: "table_orders#checkout", as: "checkout"
  get "restaurants/:restaurant_id/tables/:table_id/table_orders/:table_order_id/table_customers/:id/checkout", to: "table_customers#checkout", as: "checkout"
  get "restaurants/:restaurant_id/tables/:table_id/table_orders/:table_order_id/table_customers/:id/confirmation", to: "table_customers#confirmation", as: "confirmation"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :join_menus, only: :destroy
  resources :order_items, only: :destroy
  resources :restaurants do
    resources :restaurant_servers
    resources :menu_items
    resources :menus do
      resources :join_menus, only: %i[show new create]
    end
    resources :tables do
      resources :table_orders do
        resources :table_customers do
          resources :order_items
        end
      end
    end
  end
  get "restaurants/:restaurant_id/menus/:id/activated", to: "menus#activated!", as: "activated"
  get "restaurants/:restaurant_id/tables/:table_id/table_orders/:table_order_id/table_customers/:id/split_evenly", to: "table_customers#split_evenly", as: "split_evenly"
  get "restaurants/:restaurant_id/tables/:table_id/table_orders/:table_order_id/table_customers/:id/split_by_items", to: "table_customers#split_by_items", as: "split_by_items"
  get "restaurants/:restaurant_id/tables/:table_id/table_orders/:table_order_id/table_customers/:id/pay_all", to: "table_customers#pay_all", as: "pay_all"
  get "restaurants/:restaurant_id/tables/:table_id/table_orders/:table_order_id/table_customers/:id/card_roulette", to: "table_customers#card_roulette", as: "card_roulette"
end
