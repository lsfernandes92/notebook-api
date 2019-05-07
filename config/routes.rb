Rails.application.routes.draw do
  resources :contacts
  resources :kinds

  root 'contacts#index'
end
