Rails.application.routes.draw do
  # Rutas de monitoreo y PWA
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Rutas de operaciones financieras
  resources :ingresos, only: [:create]
  resources :gastos, only: [:create]
  resources :distribucion_utilidades, only: [:create]
  resources :retiro_utilidades, only: [:create]

  # Rutas de autenticación
  resource :session, only: [:create, :destroy]
  # Rutas POST
  post '/login', to: 'sessions#create', as: :login
  post '/signup', to: 'registrations#create'
  # Rutas GET para formularios de login y registro
  get '/login', to: 'sessions#new', as: :new_user_session
  get '/signup', to: 'registrations#new'
  get '/tablero', to: 'pages#tablero', as: :tablero
  # Página principal
  get '/home', to: 'pages#home', as: :home
  get '/dashboard', to: 'metrics#index', as: :dashboard
  root "pages#home"
end
