# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  resources :answers
  resources :questions do 
    member do 
      patch :like
      patch :unlike
      patch :dislike
      patch :undislike
    end
  end

  root 'home#index'
end
