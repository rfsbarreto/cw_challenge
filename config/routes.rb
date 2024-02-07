Rails.application.routes.draw do
  resources :transactions, only: %i[create show] do
    member do
      post :chargeback, to: 'transactions/chargeback#create'
    end
  end
end
