Rowe::Application.routes.draw do
  root :to => 'dashboard#index'
  match '/manual'   => 'dashboard#manual_index'
  get   '/settings' => 'settings#settings', :as => 'settings'
  put   '/settings' => 'settings#update', :as => 'update_settings'
  devise_for :users
end
