Rails.application.routes.draw do
  resources :transactions, only: %i[create show] do
    resources :chargebacks, only: %i[create]
  end
end
