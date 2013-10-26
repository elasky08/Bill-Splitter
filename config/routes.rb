# Primary Author: Jonathan Allen (jallen01)

BillSplitter::Application.routes.draw do
  devise_for :users
  resources :groups do
    resources :group_users, only: [:show, :create, :destroy], path: 'users', as: 'users'
    resources :items, except: [:index, :show] do
      resources :user_items, only: [:create, :destroy], path: 'users', as: 'users'
    end
  end

  # Aliases
  devise_scope :user do
    get "sign_up" => "devise/registrations#new"
    get "log_in" => "devise/session#new"
    get "log_out" => "devise/sessions#destroy"
  end

  
 
  get "group_create" => "groups#new"
  get "group_edit" => "groups#edit"
  get "group_show" => "groups#show"
  
  get "home" => "groups#index", :as => "home"

  # Route root to group index
  resources :groups
  root :to => "groups#index"


end
