Rails.application.routes.draw do
  resources :transactions, only: %i[create show] do
    post :chargeback, to: 'transactions/chargeback#create'
  end
end
