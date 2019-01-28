Rails.application.routes.draw do

  devise_for :users
  get 'pages/home'
  get 'settings/home'

  resources :dashboard

  resources :employers

  resources :settings do
    post 'create_role', to: 'settings#create_role', as: 'create_role'
    post 'create_key', to: 'settings#create_key', as: 'create_key'
    post 'create_permissions', to: 'settings#create_permissions', as: 'create_permissions'
    get 'get_roles', to: 'settings#get_roles'
    get 'get_keys', to: 'settings#get_keys'
    get 'get_permissions', to: 'settings#get_permissions'
  end

  root to: 'dashboard#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
