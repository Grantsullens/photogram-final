Rails.application.routes.draw do
  # Root route
  root "photos#index"
  
  # Devise routes
  devise_for :users, path: 'users', path_names: {
    sign_in: 'sign_in',
    sign_out: 'sign_out',
    registration: '',
    sign_up: 'sign_up'
  }
  
  # User feeds
  get "/users/:username/feed", to: "users#feed", as: :user_feed
  
  # Custom user routes
  get "/users", to: "users#index", as: :all_users
  get "/users/:username", to: "users#show", as: :user_profile
  
  # Photos resource and custom routes
  resources :photos, except: [:new, :edit]
  post "/insert_photo", to: "photos#create"
  post "/modify_photo/:id", to: "photos#update"
  get  "/delete_photo/:id", to: "photos#destroy"
  
  # Comments resource and custom routes
  resources :comments, except: [:new, :edit]
  post "/insert_comment", to: "comments#create"
  get  "/delete_comment/:id", to: "comments#destroy"
  
  # Likes resource and custom routes
  resources :likes, except: [:new, :edit]
  post "/insert_like", to: "likes#create"
  get  "/delete_like/:id", to: "likes#destroy"
  
  # Follow requests resource and custom routes
  resources :follow_requests, except: [:new, :edit]
  post "/insert_follow_request", to: "follow_requests#create"
  delete "/delete_follow_request/:id", to: "follow_requests#destroy"
end
