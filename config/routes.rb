# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'

  devise_for :users

  patch '/update_avatar', to: 'profiles#update_avatar'

  resources :answers do
    member do
      patch :choose
      patch :upvote
      patch :downvote
    end
  end

  resources :questions do
    member do
      patch :upvote
      patch :downvote
    end

    collection do
      get '/tagged/:id', to: 'tags#show', as: :tag_in
    end
  end

  resources :profiles, only: %i[show]

  resources :tags, only: %i[index show] do
    member do
      patch :follow
      patch :unfollow
    end
    collection do
      get :search
    end
  end

  resources :photos, only: %i[create show destroy]
end
