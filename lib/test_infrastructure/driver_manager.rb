module TestInfrastructure
  class DriverManager
    DRIVER_BASE_PATH = Rails.root.join('vendor', 'webdrivers')
    CHROME_VERSIONS = {
      '133' => '133.0.6943.0',
      '134' => '134.0.6998.0'
    }

    class << self
      # Método principal: configura el driver correcto para la versión detectada
      def configure_driver
        ensure_driver_directory
        
        # Verificar si existe y es ejecutable
        driver_path = TestInfrastructure::DriverConfig.chrome_path
        
        if File.exist?(driver_path.to_s) && File.executable?(driver_path.to_s)
          # Configurar el driver
          set_driver_path(driver_path)
          
          # Comprobar versiones (solo para logging)
          chrome_version = TestInfrastructure::DriverConfig.chrome_version
          driver_version = TestInfrastructure::DriverConfig.driver_version
          
          if chrome_version && driver_version
            major_chrome = chrome_version.split('.').first
            major_driver = driver_version.split('.').first
            
            if major_chrome != major_driver
              Rails.logger.warn "========================================================"
              Rails.logger.warn "ADVERTENCIA: Posible incompatibilidad de versiones"
              Rails.logger.warn "Chrome: #{chrome_version} (major: #{major_chrome})"
              Rails.logger.warn "ChromeDriver: #{driver_version} (major: #{major_driver})"
              Rails.logger.warn "Esto puede causar problemas en algunos tests"
              Rails.logger.warn "========================================================"
            end
          end
          
          Rails.logger.info "ChromeDriver configurado correctamente: #{driver_path}"
          return true
        else
          Rails.logger.error "ChromeDriver no encontrado o no ejecutable: #{driver_path}"
          Rails.logger.error "Directorio base: #{DRIVER_BASE_PATH}"
          Rails.logger.error "Archivos disponibles:"
          Dir.glob(File.join(DRIVER_BASE_PATH, '*')).each do |file|
            Rails.logger.error "  - #{file} (ejecutable: #{File.executable?(file)})"
          end
          return false
        end
      end

      # Establece la ruta del driver en Selenium
      def set_driver_path(driver_path)
        # Configuración explícita del driver para Chrome
        Selenium::WebDriver::Chrome::Service.driver_path = driver_path.to_s
      end

      # Asegura que exista el directorio base
      def ensure_driver_directory
        FileUtils.mkdir_p(DRIVER_BASE_PATH)
      end

      # Detecta si estamos en entorno WSL
      def wsl_environment?
        return true if File.exist?('/proc/version') && File.read('/proc/version').include?('Microsoft')
        return false
      end

      # SOLUCIÓN ALTERNATIVA: Configura Firefox como driver alternativo
      # Nota: Esta función siempre retornará false ya que no tenemos geckodriver
      def configure_firefox_driver
        begin
          # Intentar encontrar geckodriver instalado
          geckodriver_path = `which geckodriver 2>/dev/null`.strip
          
          if !geckodriver_path.empty? && File.executable?(geckodriver_path)
            Selenium::WebDriver::Firefox::Service.driver_path = geckodriver_path
            Rails.logger.info "Usando GeckoDriver encontrado en: #{geckodriver_path}"
            return true
          end
          
          # Verificar si existe en nuestro directorio local
          local_gecko = File.join(DRIVER_BASE_PATH, 'geckodriver')
          if File.exist?(local_gecko) && File.executable?(local_gecko)
            Selenium::WebDriver::Firefox::Service.driver_path = local_gecko
            Rails.logger.info "Usando GeckoDriver local: #{local_gecko}"
            return true
          end
          
          Rails.logger.warn "GeckoDriver no encontrado - Firefox no disponible como fallback"
          return false
        rescue => e
          Rails.logger.error "Error configurando GeckoDriver: #{e.message}"
          return false
        end
      end
    end
  end
end

