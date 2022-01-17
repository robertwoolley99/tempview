# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'temperatures#index'

  scope '/' do
    post '/weather' => 'temperatures#weather', as: :weather
  end
  resources :temperatures, only: %i[update index]
end
