# Primary Author: Jonathan Allen (jallen01)

BillSplitter::Application.routes.draw do
  devise_for :users
  resources :groups, except: [:edit] do
    member do
      post 'add_user'
      get 'remove_user'
    end

    resources :memberships, only: [:show, :update]
    resources :items, only: [:edit, :create, :update, :destroy] do
      member do
        post 'add_user'
        get 'remove_user'
      end
    end
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
