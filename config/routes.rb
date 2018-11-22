Rails.application.routes.draw do

  # Semi-static page routes
  get 'home', to: 'home#index', as: :home
  get 'home/about', to: 'home#about', as: :about
  get 'home/contact', to: 'home#contact', as: :contact
  get 'home/privacy', to: 'home#privacy', as: :privacy


  # Authentication routes
  resources :sessions
  resources :users
  get 'users/new', to: 'users#new', as: :signup
  get 'user/edit', to: 'users#edit', as: :edit_current_user
  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout


  # Resource routes (maps HTTP verbs to controller actions automatically):
  resources :officers
  resources :units
  resources :investigations
  resources :crimes
  resources :criminals
  resources :investigation_notes

  # Routes for assignments
  get 'assignments/new', to: 'assignments#new', as: :new_assignment
  post 'assignments', to: 'assignments#create', as: :assignments
  patch 'assignments/:id/terminate', to: 'assignments#terminate', as: :terminate_assignment

  # Routes for suspects
  get 'suspects/new', to: 'suspects#new', as: :new_suspect
  post 'suspects', to: 'suspects#create', as: :suspects
  patch 'suspects/:id/terminate', to: 'suspects#terminate', as: :terminate_suspect

  # Routes for crime investigations
  get 'crime_investigations/new', to: 'crime_investigations#new', as: :new_crime_investigation
  post 'crime_investigations', to: 'crime_investigations#create', as: :crime_investigations
  delete 'crime_investigations/:id/destroy', to: 'crime_investigations#destroy', as: :destroy_crime_investigation

  # Toggle paths




  # Other custom routes




  # Routes for searching




  # You can have the root of your site routed with 'root'
  root 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
