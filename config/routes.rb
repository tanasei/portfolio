Rails.application.routes.draw do
  get 'home/top'
  # 顧客用
  devise_for :customers, skip: [:passwords,], controllers: {
    registrations: 'public/registrations',
    sessions: 'public/sessions'
  }

  root 'home#top'
  get 'home/about' => 'home#about'

  namespace :public do
  #namespace :customersをpublicに変更しました。
    resource :customers, only: [:show, :update, :edit] do
      # 退会確認画面
      get '/customers/unsubscribe' => 'customers#unsubscribe', as: 'unsubscribe'
      # 論理削除用のルーティング
      patch '/customers/withdrawal' => 'customers#withdrawal', as: 'withdrawal'
    end
    resources :addresses, only: [:index, :create, :edit, :update, :destroy]
    resources :items, only: [:index, :show]
    resources :cart_items, only: [:index, :create, :update, :destroy] do
      collection do
        delete '/' => 'cart_items#all_destroy'
      end
    end
    resources :orders, only: [:new, :create, :index, :show] do
      collection do
        post 'confirm'
        get 'complate'
      end
    end
    get 'customers/unsubscribe' => 'customers#unsubscribe'
    patch 'customers/withdraw' => 'customers#withdraw'
  end

  # 管理者用
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: 'admin/sessions'
  }

  namespace :admin do
    root to: 'orders#top'
    resources :customers, only: [:index, :edit, :show, :update]
    resources :items, only: [:new, :index, :show, :edit, :update, :create]
    resources :genres, only: [:index, :edit, :create, :update]
    resources :orders, only: [:show, :update]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
