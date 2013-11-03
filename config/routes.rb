# Primary Author: Jonathan Allen (jallen01)

BillSplitter::Application.routes.draw do
  devise_for :users
  resources :groups, except: [:edit, :new] do
    member do
      post 'add_user', defaults: { format: 'js' }
      get 'remove_user', defaults: { format: 'js' }
    end

    resources :memberships, only: [:show, :update], defaults: { format: 'js'}
    resources :items, only: [:edit, :create, :update, :destroy], defaults: { format: 'js'} do
      member do
        post 'add_user', defaults: { format: 'js'}
        get 'remove_user', defaults: { format: 'js'}
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
