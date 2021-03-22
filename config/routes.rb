# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      patch :like
      patch :unlike
      patch :dislike
      patch :undislike
    end
  end

  patch '/update_avatar', to: 'application#update_avatar'

  resources :answers, concerns: :votable
  resources :questions, concerns: :votable

  root 'home#index'
end
