Oddit::Application.routes.draw do
  resources :semesters do
    member do
      put :add
      put :sync
      delete :remove
    end
  end

  resources :courses do
    get :search, :on => :collection
  end

  resources :majors do
    match :search, :on => :collection
    put :clone, :on => :member

    resources :requirement_groups, :only => [:create, :destroy, :update] do
      resources :requirements, :only => [:create, :destroy, :update]
    end
  end

  devise_for :users, :controllers => {:omniauth_callbacks => 'omniauth'} do
    get 'login'  => 'omniauth#new', :as => :new_user_session
    get 'logout' => 'omniauth#destroy', :as => :destroy_user_session
  end

  get 'users/update_major',    :as => 'update_major'
  match 'users/add_major',     :as => 'add_major'
  delete 'users/remove_major', :as => 'remove_major'

  root :to => 'home#index'

  get ':id/share' => 'users#share', :as => 'share'
  get ':id' => 'users#show', :as => 'permalink'
end
