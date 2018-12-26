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
  end

  resources :taxes
end
