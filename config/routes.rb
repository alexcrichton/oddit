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
  end

  match 'login'  => 'sessions#create'
  match 'logout' => 'sessions#destroy'

  post 'users/add_major'
  delete 'users/remove_major'

  root :to => 'users#show'
end
