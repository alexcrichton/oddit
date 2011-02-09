AuditMan::Application.routes.draw do
  resources :courses do
    get :search, :on => :collection
  end

  resources :majors

  match 'login'  => 'sessions#create'
  match 'logout' => 'sessions#destroy'

  root :to => 'majors#index'
end
