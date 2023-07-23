# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  root 'sessions#dashboard'
  get '/login', to: 'sessions#new', as: 'login'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  post '/magic', to: 'sessions#magic'
  get '/magic', to: 'sessions#magic'
  get '/login/magic_link', to: 'sessions#magic_link_login', as: :magic_link_login
  get 'auth/:provider/callback', to: 'sessions#omniauth'
  resources :leaderboard, only: %i[show index]
  resources :exam_performances, only: [:show]
  resources :registrations, only: %i[show index new]
  resources :subjects, only: [:show]
  resources :departments, only: [:show]
  resources :users, except: %i[index destroy]

  resources :magic_link_authentication do
    member do
      post 'create', to: 'magic_link_authentication#create'
    end
  end

  resources :exams, only: [:show] do
    get 'demo_exam', on: :member
    resources :registrations, only: %i[new create]
    post 'submit_exam', on: :member

    member do
      get 'conduct'
    end
  end

  scope '/exam_performances/:id' do
    get 'generate_report', to: 'exam_performances#generate_report', as: 'generate_report'
  end

  namespace :admin do
    root 'admin#index'
    resources :departments, except: [:show]
    resources :subjects, except: [:show]
    resources :exams
    resources :questions, except: [:show]
    resources :users, except: [:show]
    resources :professors, except: [:show]
  end
end
# rubocop:enable Metrics/BlockLength
