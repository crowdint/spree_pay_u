Spree::Core::Engine.routes.draw do
  namespace :pay_u do
    resources :payments, only: [:create]
  end
end
