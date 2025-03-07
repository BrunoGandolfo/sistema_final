module TestInfrastructure
  class DriverConfig
    # Ruta base para los drivers instalados
    DRIVER_BASE_PATH = Rails.root.join('vendor', 'webdrivers')
    
    class << self
      # Método principal para obtener ruta del ChromeDriver
      def chrome_path
        # Primero, verificar el driver principal
        if File.exist?(standard_driver) && File.executable?(standard_driver)
          return standard_driver
        end
        
        # Buscar en directorio chromedriver-linux64
        chrome_linux_dir = DRIVER_BASE_PATH.join('chromedriver-linux64')
        if Dir.exist?(chrome_linux_dir)
          driver_in_dir = File.join(chrome_linux_dir, 'chromedriver')
          if File.exist?(driver_in_dir) && File.executable?(driver_in_dir)
            return driver_in_dir
          end
        end
        
        # Último recurso, buscar cualquier chromedriver en el directorio
        any_driver = Dir.glob(DRIVER_BASE_PATH.join('chromedriver*')).find do |path|
          File.file?(path) && File.executable?(path)
        end
        
        # Usar el driver encontrado o volver al estándar
        return any_driver || standard_driver
      end
      
      # Obtener versión de chrome detectada
      def chrome_version
        @chrome_version ||= begin
          # Intentar desde ENV
          if ENV['CHROME_VERSION']
            version = ENV['CHROME_VERSION']
            Rails.logger.info("Usando versión de Chrome desde ENV: #{version}")
            version
          else
            # Intentar detectar desde el sistema
            output = `google-chrome --version 2>/dev/null`
            if output && !output.empty?
              version = output.strip.scan(/[\d]+\.[\d]+\.[\d]+\.[\d]+/).first
              Rails.logger.info("Versión de Chrome detectada: #{version}")
              version
            else
              # Fallback
              '133.0.6943.98'
            end
          end
        end
      end
      
      # Obtener versión del driver
      def driver_version
        @driver_version ||= begin
          # Ejecutar chromedriver para obtener su versión
          output = `#{chrome_path} --version 2>/dev/null`
          if output && !output.empty?
            version = output.strip.scan(/[\d]+\.[\d]+\.[\d]+\.[\d]+/).first
            Rails.logger.info("Versión de ChromeDriver detectada: #{version}")
            version
          else
            # Si no se puede determinar
            '134.0.6998.35'
          end
        end
      end
      
      private
      
      # Ruta estándar del chromedriver
      def standard_driver
        DRIVER_BASE_PATH.join('chromedriver').to_s
      end
    end
  end
end
