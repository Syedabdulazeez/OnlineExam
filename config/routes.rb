Rails.application.routes.draw do
  get 'leaderboard/index'
  get 'magic_link_authentication/create'
  root  'application#dashboard'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/login', to: 'sessions#new', as: 'login'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get 'auth/:provider/callback', to: 'sessions#omniauth'
  post '/magic' , to: 'sessions#magic'
  get '/magic' , to: 'sessions#magic'
  post '/magic_link_authentication', to: 'magic_link_authentication#create'
  get '/magic_link_authentication', to: 'magic_link_authentication#create'
  get '/login/magic_link', to: 'sessions#magic_link_login', as: :magic_link_login
  get 'dashboard', to: 'dashboard#index'
  get '/exams/:exam_id/registrations/new', to: 'registrations#new', as: 'new_exam_registration'

  resources :leaderboard
  resources :exam_performances
  resources :options
  resources :questions
  resources :exams, only: [:show] do
    resources :registrations, only: [:new, :create]
    post 'submit_exam', on: :member
    member do
      get 'conduct'
    end
  end
  namespace :admin do
    root 'admin#index'
    resources :departments
    resources :subjects
    resources :exams
    resources :questions
    resources :users
    
  end
  resources :registrations
  resources :subjects
  resources :departments
  resources :users
  # resources :sessions
  get '/exam_performances/:id/generate_report', to: 'exam_performances#generate_report', as: 'generate_report'
  # get 'leaderboard/generate_report', to: 'leaderboard#generate_report', as: 'generate_report'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
