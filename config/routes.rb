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
    get :yearly, on: :collection, controller: 'purchases/yearly', to: 'purchases/yearly#index'
    get :expense, on: :collection, controller: 'purchases/expense', to: 'purchases/expense#index'
    get :frequent, on: :collection, controller: 'purchases/frequent', to: 'purchases/frequent#index'
    get :total_per_month, on: :collection, controller: 'purchases/total_per_month', to: 'purchases/total_per_month#index'
  end

  resources :taxes
end
