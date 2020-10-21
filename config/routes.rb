Rails.application.routes.draw do
  root 'groups#index'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :groups, only: [:index, :create, :update, :destroy] do
    resources :question_answers, only: [:index, :new, :create] do
      collection do
        get 'review', 'change_date' # change_dateは挙動確認用。アプリリリース時には削除
      end
    end
  end

  resources :question_answers, only: [:edit, :update, :destroy] do
    resources :shares, only: [:create, :destroy]
    member do
      patch 'reset', 'remove'
    end
  end

  resources :category_seconds, only: [:index] do
    resources :shares, only: [:index]
    collection do
      get 'search'
    end
  end
  
  resources :options, only: [:edit, :update]
  patch '/repetition_algorithms', to: 'repetition_algorithms#update'
  # 挙動確認用。アプリリリース時には削除。
  patch '/repetition_algorithms/change_date', to: 'repetition_algorithms#change_date'
end
