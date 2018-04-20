# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'welcome#index'

  scope path: '/admin' do
    devise_for :users
    get 'welcome/index'
  end
  namespace :admin do
    resources :rebate_forms
    get 'signatures' => 'signatures#show'
  end

  scope path: '/api' do
    resources :docs, only: [:index], path: '/swagger'

    scope path: '/v1' do
      resources :rebate_forms, only: %i[create show update]
      resources :signature_types, only: %i[index show]
      resources :signatures, only: %i[show create]
    end
  end
end
