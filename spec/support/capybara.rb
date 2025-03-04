require 'capybara/rspec'
require 'selenium-webdriver'

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--disable-gpu')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

# Configuración predeterminada
Capybara.default_driver = :rack_test
Capybara.javascript_driver = :chrome_headless
Capybara.default_max_wait_time = 5

# Configuración específica para pruebas de sistema
RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :chrome_headless
  end

  # Guardar screenshots en caso de fallos
  config.after(:each, type: :system) do |example|
    if example.exception && page.respond_to?(:save_screenshot)
      # Aseguramos que el directorio existe
      FileUtils.mkdir_p 'tmp/screenshots'
      begin
        page.save_screenshot("tmp/screenshots/#{example.description.gsub(/\s+/, '_').gsub(/[^0-9A-Za-z_]/, '')}.png")
      rescue => e
        puts "No se pudo guardar la captura: #{e.message}"
      end
    end
  end
end
