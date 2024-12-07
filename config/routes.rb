Rails.application.routes.draw do
  # Devise authentication routes for User model
  devise_for :users

  # Set the root of the application
  # Adjust this if your root should be something else
  root "photos#index"

  # Users
  # Public index of all users
  get "/users", to: "users#index", as: :users

  # Public profile of a user by username
  get "/users/:username", to: "users#show", as: :user_profile

  # Photos resource routes
  resources :photos, except: [:new, :edit]

  # Comments resource routes
  resources :comments, except: [:new, :edit]

  # Likes resource routes
  resources :likes, except: [:new, :edit]

  # Follow requests resource routes
  resources :follow_requests, except: [:new, :edit]
end
