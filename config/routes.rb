Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "static_pages#index"
  get "/users/sign_up", to:"users#new"
  post "/users", to:"users#create"
  get "/users/sign_in", to:"sessions#new"
  get "/users/:id/password", to:"passwords#edit"
  post "/users/sign_in", to: "sessions#create"
  delete "/users/sign_out", to:"sessions#destroy"
  patch "/users/:id/password", to:"passwords#update" 
  get "/users/password/reset", to:"password_resets#new"
  post "/users/password/reset", to:"password_resets#create"
  get "/users/password/reset/edit", to:"password_resets#edit"
  patch "/users/password/reset/edit", to:"password_resets#update"
  get "auth/twitter/callback", to:"omniauth_callbacks#twitter"

  resources :twitter_accounts

  resources :tweets
  get "/tweets/:id/publish" , to:"tweets#publish_to_twitter"
end
