# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'welcome#index'

  scope path: '/admin' do
    get 'welcome/index'
  end

  scope path: '/api' do
    resources :docs, only: [:index], path: '/swagger'

    scope path: '/v1' do
      resources :rebate_forms, only: [:create, :show]
      resources :signature_types, only: [:index, :show]
      resources :signatures, only: [:show, :create]
    end
  end
end
