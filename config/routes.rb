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
  get '/login', to: 'sessions#new'
  get '/signup', to: 'registrations#new'

  # Página principal
  get '/home', to: 'pages#home', as: :home
  root "pages#home"
end
