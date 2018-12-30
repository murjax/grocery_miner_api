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

  resources :items do
    get :monthly, on: :collection, controller: 'items/monthly', to: 'items/monthly#index'
    get :yearly, on: :collection, controller: 'items/yearly', to: 'items/yearly#index'
    get :expense, on: :collection, controller: 'items/expense', to: 'items/expense#index'
    get :frequent, on: :collection, controller: 'items/frequent', to: 'items/frequent#index'
    get :total_per_month, on: :collection, controller: 'items/total_per_month', to: 'items/total_per_month#index'
  end

  resources :taxes
end
