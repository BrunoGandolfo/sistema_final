require_relative "boot"
# En lugar de rails/all, cargamos manualmente los railties que necesitamos
require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# NO requerimos sprockets/railtie
# require "sprockets/railtie"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module SistemaFinal
  class Application < Rails::Application
    # Configuración para Rails 7
    config.load_defaults 7.0
    
    # Configuración del idioma a español
    config.i18n.default_locale = :es
    config.i18n.available_locales = [:es, :en]
    
    # Zona horaria de Uruguay
    config.time_zone = 'Montevideo'
    
    # No generar código innecesario en generadores
    config.generators do |g|
      g.skip_routes true
      g.helper false
      g.assets false
      g.test_framework :rspec
      g.system_tests nil
    end
    
    # Permitir hosts locales en desarrollo
   config.hosts = config.hosts.dup << "localhost" if Rails.env.development?    
    # Configurar Active Job para usar async
    config.active_job.queue_adapter = :async
  end
end
