Rails.application.routes.draw do
  devise_for :users
  root 'groups#index'
  resources :users, only: [:edit, :update]
  resources :groups, only: [:index, :create, :update] do
    resources :question_answers, only: [:index, :show, :new, :create, :edit, :update]
  end
end
