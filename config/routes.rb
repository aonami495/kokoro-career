Rails.application.routes.draw do
  devise_for :users

  # 求人検索（公開）
  resources :jobs, only: [:index, :show] do
    resources :applications, only: [:create]
  end

  # 通報機能
  resources :reports, only: [:new, :create]

  # 応募に紐づくメッセージと実習
  resources :applications, only: [] do
    resources :messages, only: [:index, :create]
    resource :internship, only: [:create, :update]
  end

  # 実習詳細・日報
  resources :internships, only: [:show] do
    patch :update_status, on: :member
    resources :daily_reports, only: [:create]
  end

  # 求職者用ルーティング
  namespace :job_seeker do
    get "dashboard", to: "dashboard#show", as: :dashboard
    resource :accommodations, only: [:show, :new, :create, :edit, :update]
  end

  # 企業用ルーティング
  namespace :company do
    get "dashboard", to: "dashboard#show", as: :dashboard
    resource :accommodations, only: [:show, :edit, :update]
    resources :jobs, only: [:index, :new, :create, :edit, :update]
    resources :applications, only: [:index]
  end

  # 管理者用ルーティング
  namespace :admin do
    resource :dashboard, only: [:show]
    resources :users, only: [:index, :destroy]
    resources :jobs, only: [:index, :destroy]
    resources :accommodation_tags, except: [:show]
    resources :reports, only: [:index, :show] do
      patch :update_status, on: :member
    end
  end

  # 静的ページ
  get "guide/enterprise", to: "pages#enterprise_guide", as: :enterprise_guide
  root "pages#home"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
