# frozen_string_literal: true

Rails.application.routes.draw do
  root to: redirect('/admin')

  scope path: '/admin' do
    devise_for :users
    get '/' => 'admin/rebate_forms#index'
  end

  namespace :admin do
    get 'rebate_forms/signed', to: 'signed_rebate_forms#index'
    get 'rebate_forms/processed', to: 'processed_rebate_forms#index'
    post 'process_rebate_form', to: 'processed_rebate_forms#create'
    delete 'unprocess_rebate_form', to: 'processed_rebate_forms#destroy'
    delete 'unprocess_rebate_forms', to: 'processed_rebate_forms#destroy_all'

    resources :rebate_forms do
      get 'generateqr'
    end
    resources :attachments, only: %i[destroy]
    resources :councils do
      resources :properties
    end
    resources :users
    resources :batches
    get 'signature' => 'signatures#show'
  end

  scope path: '/api' do
    resources :docs, only: [:index], path: '/swagger'

    scope path: '/v1' do
      post '/rebate_forms/sign' => 'sign_rebate_forms#sign'
      get '/rebate_forms/' => 'rebate_forms#show_by_jwt'
      resources :councils
      resources :rates_payers, only: %(show)
      resources :rates_bills, only: %(show)
      resources :properties, only: %(index show)
      resources :rebate_forms, only: %i[create]
      resources :properties, only: %i[show index]
      resources :signature_types, only: %i[index show]
      resources :signatures, only: %i[create]
    end
  end
end
