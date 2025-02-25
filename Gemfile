source "https://rubygems.org"

# Rails
gem "rails", "~> 7.2.2", ">= 7.2.2.1"

# Eliminar Sprockets (comentado o borrarlo por completo)
# gem "sprockets-rails"

# Base de datos
gem "pg", "~> 1.1"

# Servidor
gem "puma", ">= 5.0"

# JavaScript con import maps
gem "importmap-rails"

# Turbo (Hotwire)
gem "turbo-rails"

# Stimulus (comentado o borrarlo por completo)
# gem "stimulus-rails"

# Tailwind CSS
#gem "tailwindcss-rails"

# Construcción de JSON APIs (opcional)
gem "jbuilder"

# Solo necesario en Windows/JRuby
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Carga rápida en desarrollo
gem "bootsnap", require: false

# Bcrypt para has_secure_password
gem "bcrypt", "~> 3.1"

# RSpec para pruebas
gem "rspec-rails", "~> 7.1"

group :development, :test do
  # Herramienta de depuración
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"

  # Análisis de seguridad
  gem "brakeman", require: false

  # Estilo Ruby on Rails
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Web console
  gem "web-console"
end

group :test do
  gem 'simplecov', require: false
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
    gem 'rails-controller-testing'
  gem "factory_bot_rails"
  gem "shoulda-matchers", "~> 5.0"
  gem 'diff-lcs', '1.6.0'
 end
