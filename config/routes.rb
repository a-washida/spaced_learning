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
    resources :shares, only: [:create, :destroy] do
      post 'import', on: :member
    end
    member do
      patch 'reset', 'remove'
    end
  end

  resources :category_seconds, only: [:index] do
    get 'search', on: :collection
    resources :shares, only: [:index], shallow: true do
      resources :likes, only: [:create, :destroy]
    end
  end

  resources :options, only: [:edit, :update]
  patch '/repetition_algorithms/:id', to: 'repetition_algorithms#update'
  # 挙動確認用。アプリリリース時には削除。
  patch '/change_date/repetition_algorithms/:id', to: 'repetition_algorithms#change_date'
end
