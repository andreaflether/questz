# frozen_string_literal: true

Rails.application.routes.draw do
  resources :answers
  resources :questions
  devise_for :users
  root 'home#index'
end
