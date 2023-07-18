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
  resources :magic_link_authentications
  resources :dashboards
  resources :leaderboard
  resources :exam_performances
  resources :options
  resources :questions
  resources :registrations
  resources :subjects
  resources :departments
  resources :users

  resources :magic_link_authentication do
    member do
      post 'create', to: 'magic_link_authentication#create'
    end
  end

  resources :exams do
    resources :registrations
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
    resources :departments
    resources :subjects
    resources :exams
    resources :questions
    resources :users
    resources :professors
  end
end
# rubocop:enable Metrics/BlockLength
