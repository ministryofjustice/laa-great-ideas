# frozen_string_literal: true

Rails.application.routes.draw do
  resources :ideas do
    post 'submit', to: 'ideas#submit'
    resources :comments
  end
  devise_for :users,
             controllers: { registrations: 'registrations' },
             path: '',
             path_names: { sign_in: 'sign_in', sign_out: 'sign_out', sign_up: 'sign_up' }
  resources :users, only: %i[index show] do
    post 'toggle_admin', to: 'users#toggle_admin'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # Set up default root
  root to: 'ideas#index'
end
