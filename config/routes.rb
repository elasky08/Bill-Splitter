BillSplitter::Application.routes.draw do
  devise_for :users
  # Aliases
  # get "sign_up" => "users#new", :as => "sign_up"
  # get "log_in" => "logins#new", :as => "log_in"
  # get "log_out" => "logins#destroy", :as => "log_out"

  # Route root to group index
  root :to => "groups#index"

end
