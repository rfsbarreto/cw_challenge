Rails.application.routes.draw do
  namespace :transactions do
    get 'chargebacks/create'
  end
  resources :transactions, only: %i[create show] do
    resources :chargebacks, only: %i[create]
  end
end
