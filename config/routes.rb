AuditMan::Application.routes.draw do
  get 'courses/search'

  resources :majors

  match 'login'  => 'sessions#create'
  match 'logout' => 'sessions#destroy'

  root :to => 'majors#index'
end
