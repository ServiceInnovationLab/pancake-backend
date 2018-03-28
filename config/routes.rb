# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'welcome#index'
  get 'welcome/index'
  scope path: '/api' do
    resources :docs, only: [:index], path: '/swagger'

    scope path: '/v1' do
      resources :rebate_forms, only: [:create]
      resources :signature_types, only: [:index, :show]
      resources :signatures, only: [:show, :create]
      # your routes go here
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
