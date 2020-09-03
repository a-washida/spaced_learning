Rails.application.routes.draw do
  devise_for :users
  root 'groups#index'
  resources :groups, only: [:index, :create, :update, :destroy] do
    resources :question_answers do
      collection do
        get 'review', 'change_date'
      end
    end
  end
  post '/repetition_algorithms', to: 'repetition_algorithms#update'
end
