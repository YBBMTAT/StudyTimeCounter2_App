Rails.application.routes.draw do
  devise_for :users
  root to: "timers#index"
  resources :timers, only: [:index, :show]
  resources :usersettings, only: [:edit, :update] do
    get 'countdown_setting', on: :collection
  end
  post '/timers/save', to: 'timers#save'
end
