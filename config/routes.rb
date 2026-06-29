Rails.application.routes.draw do
  root "pages#home"

  devise_for :users

  get "about", to: "pages#about"
  resources :users, only: %i[ show ]

  resources :requests, only: %i[ create ] do
    member do
      post :accept
      post :reject
    end
  end

  resources :posts, only: %i[ index new create show ]
  resources :comments, only: %i[ create ]
  resources :likes, only: %i[ create ] do
    delete :unlike, on: :collection
  end
end
