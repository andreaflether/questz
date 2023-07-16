# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'questions#feed', as: :authenticated_root

  match '/404', to: 'errors#not_found', via: :all
  match '/422', to: 'errors#unprocessable_entity', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  devise_for :users

  namespace :admin do
    get :index, path: '/', as: ''

    resources :questions, except: %i[new create], param: :slug do
      member do
        patch :close
        patch :reopen
        get :close_modal
      end
    end

    resources :reports, only: %i[show index], param: :number do
      member do
        patch :close
        patch :assign
        patch :solve
        get :close_modal
      end

      collection do
        get :opened
      end
    end

    resources :users, ony: %i[index edit update], param: :username
    resources :tags, only: %i[index destroy], param: :name
    resources :answers, only: %i[destroy]
  end

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
  get '/community', to: 'profiles#community'
  get '/reports', to: 'profiles#reports'

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

  notify_to :users,
            with_devise: :users,
            devise_default_routes: true,
            with_subscription: true,
            controller: 'users/notifications_with_devise'
end
