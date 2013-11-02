# Primary Author: Jonathan Allen (jallen01)

BillSplitter::Application.routes.draw do
  devise_for :users
  resources :groups, except: [:edit] do
    resources :memberships, only: [:show, :create, :destroy]
    resources :items, only: [:edit, :create, :update, :destroy]
    resources :partitions, only: [:show, :create, :destroy]
  end

  # Aliases
  devise_scope :user do
    get "sign_up" => "devise/registrations#new"
    get "log_in" => "devise/session#new"
    get "log_out" => "devise/sessions#destroy"
  end

  # Route root to group index
  root :to => "groups#index"


end
