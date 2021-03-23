# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  patch '/update_avatar', to: 'application#update_avatar'

  resources :answers

  resources :questions do
    member do
      patch :like
      patch :dislike
    end
    collection do
      get '/tagged/:tag', to: 'questions#tagged'
    end
  end

  resources :tags, only: %i[index show]

  root 'home#index'
end
