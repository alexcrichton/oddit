AuditMan::Application.routes.draw do
  resources :majors

  match 'login'  => 'sessions#create'
  match 'logout' => 'sessions#destroy'

  root :to => 'majors#index'
end
