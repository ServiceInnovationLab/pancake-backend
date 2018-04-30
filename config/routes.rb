# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'welcome#index'

  scope path: '/admin' do
    devise_for :users
    get 'welcome/index'
  end
  namespace :admin do
    resources :rebate_forms
    get 'signature' => 'signatures#show'
  end

  scope path: '/api' do
    resources :docs, only: [:index], path: '/swagger'

    scope path: '/v1' do
      resources :rates_payers, only: %(show)
      resources :rates_bills, only: %(show)
      resources :properties, only: %(index show)
      resources :rebate_forms, only: %i[create show update]
      resources :properties, only: [:show, :index]

      resources :signature_types, only: %i[index show]
      resources :signatures, only: %i[create]
    end
  end
end
