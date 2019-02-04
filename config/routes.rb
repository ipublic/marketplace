Rails.application.routes.draw do

  devise_for :users
  get 'pages/home'
  get 'settings/home'

  resources :dashboard

  resources :notifications

  resources :employers do
    get 'get_employers'
    resources :accounts, only: [:show] do 
    end
    resources :wage_reports, shallow: true do
      resources :wage_entries
    end
  end

  resources :tpas do
    get 'get_tpas'
  end

  # resources : do


  # end


  resources :settings do
    post 'create_role', to: 'settings#create_role', as: 'create_role'
    post 'create_key', to: 'settings#create_key', as: 'create_key'
    post 'create_permissions', to: 'settings#create_permissions', as: 'create_permissions'
    get 'get_roles', to: 'settings#get_roles'
    get 'get_keys', to: 'settings#get_keys'
    get 'get_permissions', to: 'settings#get_permissions'
    delete 'remove_role_and_permissions', to: 'settings#remove_role_and_permissions'
  end

  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
