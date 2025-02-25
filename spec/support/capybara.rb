RSpec.configure do |config|
  config.after(:each, type: :system) do |example|
    if example.exception && page.driver.respond_to?(:save_screenshot)
      begin
        # Aseguramos que el directorio existe
        FileUtils.mkdir_p 'tmp/screenshots'
        page.save_screenshot("tmp/screenshots/#{example.description.gsub(/\s+/, '_').gsub(/[^0-9A-Za-z_]/, '')}.png")
      rescue StandardError => e
        # Si el driver no soporta la función, ignoramos el error
      end
    end
  end
end
