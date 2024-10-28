Rails.application.routes.draw do
  # devise_for :users
  devise_for :users, controllers: { registrations: "users/registrations" }
  root "products#index"
  resources :products
  resources :orders, only: [ :index, :show, :create ] do
    member do
      patch :confirm
      delete :cancel
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
