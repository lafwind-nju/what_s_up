Rails.application.routes.draw do
  get 'static_pages/home'

  devise_for :users

  resources :users, only: [:show] do
    resources :groups do
    end
  end

  resources :posts do
    resources :comments
    member do
      get "like", to: "posts#like"
      get "unlike", to: "posts#unlike"
      put "share", to: "posts#share"
    end
  end

  authenticated :user do
    root 'posts#index', as: 'authenticated_root'
  end

  root 'static_pages#home'
end
