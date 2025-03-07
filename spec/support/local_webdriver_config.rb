module LocalWebdriverConfig
  CHROME_DRIVER_PATH = Rails.root.join('vendor', 'webdrivers', 'chromedriver')
  
  def self.configure
    if File.exist?(CHROME_DRIVER_PATH) && File.executable?(CHROME_DRIVER_PATH)
      Selenium::WebDriver::Chrome::Service.driver_path = CHROME_DRIVER_PATH
      Rails.logger.info "Usando ChromeDriver local: #{CHROME_DRIVER_PATH}"
      return true
    else
      Rails.logger.error "ChromeDriver no encontrado en #{CHROME_DRIVER_PATH}"
      Rails.logger.error "Por favor, ejecute: bin/setup_webdrivers_manual"
      return false
    end
  end
end 