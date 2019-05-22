Rails.application.routes.draw do
  devise_for :users,
    path: '',
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      registration: 'signup'
    },
    controllers: {
      sessions: 'sessions',
      registrations: 'registrations'
    }
  root to: 'home#index'

  jsonapi_resources :items

  jsonapi_resources :purchases do
    jsonapi_relationships
    get :total_per_month, on: :collection, controller: 'purchases/total_per_month', to: 'purchases/total_per_month#index'
  end

  resources :taxes
end
