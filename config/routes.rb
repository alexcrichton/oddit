AuditMan::Application.routes.draw do
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
    get :search, :on => :collection
    put :clone, :on => :member
  end

  get 'login'                     => 'sessions#new'
  match 'auth/:provider/callback' => 'sessions#create'
  match 'auth/failure'            => 'sessions#failure'
  match 'logout'                  => 'sessions#destroy'

  get 'users/update_major',    :as => 'update_major'
  post 'users/add_major',      :as => 'add_major'
  delete 'users/remove_major', :as => 'remove_major'

  root :to => 'users#home'

  match ':id' => 'users#show'
end
