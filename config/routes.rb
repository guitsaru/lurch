Lurch::Application.routes.draw do

  resources :github,  :only => :create
  resources :jenkins, :only => :create
  resources :settings
  resources :projects
  resources :builds

  root :to => 'projects#index'
end
