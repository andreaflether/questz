# frozen_string_literal: true

Rails.application.routes.draw do
  authenticated :user do root to: 'questions#feed' end

  match '/404', to: 'errors#not_found', via: :all
  match '/422', to: 'errors#unprocessable_entity', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  devise_for :users

  patch '/update_avatar', to: 'profiles#update_avatar'

  resources :questions do
    member do
      patch :upvote
      patch :downvote
    end

    collection do
      get '/tagged/:id', to: 'tags#show', as: :tag_in
      get :search
    end

    resources :answers, except: %i[index show] do
      member do
        patch :choose
        patch :upvote
        patch :downvote
      end
    end

    resources :reports, only: %i[new create], module: :questions
  end

  resources :answers, only: [:verify] do
    resources :reports, only: %i[new create], module: :answers
  end

  get '/feed', to: 'questions#feed'
  get '/reputation', to: 'profiles#reputation'

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

  notify_to :users, with_devise: :users, devise_default_routes: true, with_subscription: true
end
