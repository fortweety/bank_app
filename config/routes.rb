Rails.application.routes.draw do
  # devise_for :users
  devise_for :user, :controllers => { :sessions => "devise/sessions" }, :skip => [:registrations]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'users#show'
  resources :transactions, only: %i(create new show)
end
