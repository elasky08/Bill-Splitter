BillSplitter::Application.routes.draw do
  devise_for :users
  resources :groups do
    member do
      post 'users', to: 'groups#add_user'
      delete 'users/:email', to: 'groups#remove_user'

      get 'bill', to: 'groups#bill'

    end
  end

  resources :items, except: [:index, :show] do
    member do
      post 'users', to: 'items#add_user'
      delete 'users/:email', to: 'items#remove_user'
    end
  end

  resources :bills, only: [:show, ]

  # Aliases
  devise_scope :user do
    get "sign_up" => "devise/registrations#new"
    get "log_in" => "devise/session#new"
    get "log_out" => "devise/sessions#destroy"
  end
  
  get "home" => "groups#index", :as => "home"

  # Route root to group index
  root :to => "groups#index"

end
