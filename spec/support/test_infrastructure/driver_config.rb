module TestInfrastructure
  class DriverConfig
    CHROME_VERSION = "133.0.6943.98"
    DRIVER_FILE = "chromedriver_#{CHROME_VERSION}"

    class << self
      def chrome_path
        path = Rails.root.join('vendor', 'webdrivers', DRIVER_FILE).to_s
        unless File.exist?(path) && File.executable?(path)
          Rails.logger.error "ChromeDriver no encontrado en #{path}"
          Rails.logger.error "Por favor, ejecute: bin/setup_webdrivers_manual"
          raise "ChromeDriver no encontrado o no ejecutable"
        end
        
        path
      end

      def verify_driver_installation
        chrome_path
        true
      rescue => e
        Rails.logger.error e.message
        false
      end
    end
  end
end 