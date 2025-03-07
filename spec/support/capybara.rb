require 'capybara/rspec'
require 'selenium-webdriver'
require 'webdrivers'
require 'open-uri'
require 'net/http'
require 'test_infrastructure/driver_config'
require 'test_infrastructure/driver_manager'

# Configuración de logging para debugging
Webdrivers.logger.level = :DEBUG
Selenium::WebDriver.logger.level = :DEBUG

# Asegurar que existan los directorios necesarios
FileUtils.mkdir_p(Rails.root.join('tmp', 'capybara'))
FileUtils.mkdir_p(Rails.root.join('tmp', 'webdrivers'))

# Desactivar descarga automática de WebDrivers
Webdrivers.install_dir = Rails.root.join('vendor', 'webdrivers').to_s
ENV['WD_DISABLE_DOWNLOAD'] = 'true'

# Configuración simplificada para ChromeDriver
Rails.logger.info "Utilizando ChromeDriver local: #{TestInfrastructure::DriverConfig.chrome_path}"
Rails.logger.info "Versión de Chrome detectada: #{TestInfrastructure::DriverConfig.chrome_version}"
Rails.logger.info "Versión de ChromeDriver: #{TestInfrastructure::DriverConfig.driver_version}"

# Configuración de drivers
Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--window-size=1920,1080')
  options.add_argument('--disable-site-isolation-trials')

  # Usar el adapter para la configuración del driver
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options,
    service: Selenium::WebDriver::Chrome::Service.new(
      path: TestInfrastructure::DriverConfig.chrome_path
    ),
    clear_local_storage: true,
    clear_session_storage: true
  )
end

# Registrar el driver chrome_headless (alias de selenium_chrome_headless)
Capybara.register_driver :chrome_headless do |app|
  Rails.logger.info "Configurando driver chrome_headless..."

  options = Selenium::WebDriver::Chrome::Options.new

  # Configuración básica para headless
  options.add_argument('--headless')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--disable-gpu')
  options.add_argument('--window-size=1920,1080')

  # Configuraciones adicionales para WSL
  if TestInfrastructure::DriverManager.wsl_environment?
    Rails.logger.info "Detectado entorno WSL, aplicando configuración específica..."
    if ENV['CHROME_TMP_DIR']
      options.add_argument("--user-data-dir=#{ENV['CHROME_TMP_DIR']}")
    end
  end

  begin
    # Configurar ChromeDriver service explícitamente con nuestra ruta local
    chrome_service = Selenium::WebDriver::Chrome::Service.new(
      path: TestInfrastructure::DriverConfig.chrome_path
    )
    
    Rails.logger.info "Creando driver Chrome con service path: #{chrome_service.path}"
    
    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      options: options,
      service: chrome_service
    )
  rescue => e
    Rails.logger.error "Error configurando driver Chrome: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    raise
  end
end

# Alias selenium_chrome_headless al chrome_headless
Capybara.register_driver :selenium_chrome_headless do |app|
  Capybara.drivers[:chrome_headless].call(app)
end

# Mantener la configuración de Firefox como fallback
Capybara.register_driver :firefox_headless do |app|
  options = Selenium::WebDriver::Firefox::Options.new
  options.add_argument('-headless')
  Capybara::Selenium::Driver.new(app, browser: :firefox, options: options)
end

# Configuración general de Capybara
Capybara.configure do |config|
  config.default_driver = :chrome_headless
  config.javascript_driver = :chrome_headless
  config.default_max_wait_time = 10
  config.server = :puma, { Silent: true }
  config.enable_aria_label = true
  config.automatic_label_click = true
  config.default_normalize_ws = true

  # Configurar directorio de screenshots
  config.save_path = Rails.root.join('tmp', 'capybara')
end

# Configuración de RSpec
RSpec.configure do |config|
  config.before(:each, type: :system) do
    # Usar siempre chrome_headless, no intentar fallback a Firefox
    driven_by :chrome_headless
  end

  config.after(:each, type: :system) do |example|
    if example.exception
      Rails.logger.error "Test fallido: #{example.description}"
      Rails.logger.error "Error: #{example.exception.message}"

      # Guardar evidencia en caso de fallo
      timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
      filename = "#{timestamp}_#{example.description.gsub(/\s+/, '_').gsub(/[^0-9A-Za-z_]/, '')}"

      begin
        page.save_screenshot("#{config.save_path}/#{filename}.png")
        File.write("#{config.save_path}/#{filename}.html", page.html)
        Rails.logger.info "Evidencia guardada en: #{config.save_path}/#{filename}.[png|html]"
      rescue => e
        Rails.logger.error "Error guardando evidencia: #{e.message}"
      end
    end
  end
end
