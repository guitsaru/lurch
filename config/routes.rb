Lurch::Application.routes.draw do
  resources :github,  :only => :create
  resources :jenkins, :only => :create
  resources :settings
  resources :projects do
    resources :builds
  end
  resources :builds

  root :to => 'projects#index'
end
