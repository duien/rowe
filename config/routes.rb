Rowe::Application.routes.draw do
  root :to => 'dashboard#index'
  
  get '/settings/account'  => 'settings#account',         :as => 'account_settings'
  put '/settings/account'  => 'settings#update_account',  :as => 'update_account_settings'

  get '/settings/projects' => 'settings#projects',        :as => 'projects_settings'
  put '/settings/projects' => 'settings#update_projects', :as => 'update_projects_settings'

  get '/settings/vacation' => 'settings#vacation',        :as => 'vacation_settings'
  put '/settings/vacation' => 'settings#update_vacation', :as => 'update_vacation_settings'

  devise_for :users
end
