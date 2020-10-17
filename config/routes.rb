Rails.application.routes.draw do
  root 'groups#index'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :groups, only: [:index, :create, :update, :destroy] do
    resources :question_answers, except: [:show] do
      collection do
        get 'review', 'change_date' # change_dateは挙動確認用。アプリリリース時には削除
      end
      member do
        patch 'reset', 'remove'
      end
    end
  end
  resources :question_answers, only: [:show] do
    resources :shares, only: [:create, :destroy]
  end
  resources :options, only: [:edit, :update]
  get '/search_category', to: 'shares#search_category'
  patch '/repetition_algorithms', to: 'repetition_algorithms#update'
  # 挙動確認用。アプリリリース時には削除。
  patch '/repetition_algorithms/change_date', to: 'repetition_algorithms#change_date'
end
