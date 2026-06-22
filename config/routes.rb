Rails.application.routes.draw do
  root "pages#home"

  devise_for :users

  get "about", to: "pages#about"
  resources :users, only: %i[ show ]
end
