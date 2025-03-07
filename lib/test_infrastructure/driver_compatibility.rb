module TestInfrastructure
  class DriverCompatibility
    # Directorio base para los WebDrivers
    DRIVER_BASE_PATH = Rails.root.join('vendor', 'webdrivers')

    # Matriz de compatibilidad expandida con niveles
    COMPATIBILITY_MATRIX = {
      '133' => {
        'exact' => ['133.0.6943.0'],
        'compatible' => ['134.0.6998.0'],
        'fallback' => ['132.0.6222.0']
      },
      '134' => {
        'exact' => ['134.0.6998.0'],
        'compatible' => ['133.0.6943.0'],
        'fallback' => ['135.0.7071.0']
      }
    }

    # Archivo para registro de éxitos/fallos
    SUCCESS_HISTORY_FILE = Rails.root.join('vendor', 'webdrivers', 'success_history.json')

    class << self
      def compatible?(chrome_version, driver_version)
        chrome_major = extract_major_version(chrome_version)
        
        # Verificar en matriz expandida
        return true if exact_match?(chrome_major, driver_version)
        return true if compatible_match?(chrome_major, driver_version)
        return true if fallback_match?(chrome_major, driver_version)
        
        # Verificar en historial de éxitos
        successful_in_history?(chrome_version, driver_version)
      end

      def extract_major_version(version)
        version.to_s.split('.').first
      end

      def available_drivers
        # Buscar todos los archivos chromedriver en el directorio de webdrivers
        Dir.glob(File.join(DRIVER_BASE_PATH, 'chromedriver*'))
          .select { |f| File.file?(f) && File.executable?(f) }
      end

      def find_best_driver(chrome_version, available_drivers)
        chrome_major = extract_major_version(chrome_version)
        return nil unless COMPATIBILITY_MATRIX[chrome_major]

        # Intentar encontrar coincidencia exacta
        COMPATIBILITY_MATRIX[chrome_major]['exact'].each do |version|
          driver = available_drivers.find { |d| d.include?(version) }
          return driver if driver
        end

        # Intentar encontrar versión compatible
        COMPATIBILITY_MATRIX[chrome_major]['compatible'].each do |version|
          driver = available_drivers.find { |d| d.include?(version) }
          return driver if driver
        end

        # Intentar fallback como último recurso
        COMPATIBILITY_MATRIX[chrome_major]['fallback'].each do |version|
          driver = available_drivers.find { |d| d.include?(version) }
          return driver if driver
        end

        # Si no hay coincidencias, devolver el primer driver disponible
        available_drivers.first
      end

      def record_success(chrome_version, driver_version)
        history = load_success_history
        
        chrome_key = normalize_version(chrome_version)
        driver_key = normalize_version(driver_version)
        
        history[chrome_key] ||= {}
        history[chrome_key][driver_key] ||= { 'success' => 0, 'failure' => 0 }
        history[chrome_key][driver_key]['success'] += 1
        
        save_success_history(history)
      end

      def record_failure(chrome_version, driver_version)
        history = load_success_history
        
        chrome_key = normalize_version(chrome_version)
        driver_key = normalize_version(driver_version)
        
        history[chrome_key] ||= {}
        history[chrome_key][driver_key] ||= { 'success' => 0, 'failure' => 0 }
        history[chrome_key][driver_key]['failure'] += 1
        
        save_success_history(history)
      end

      private

      def exact_match?(chrome_major, driver_version)
        return false unless COMPATIBILITY_MATRIX[chrome_major]
        COMPATIBILITY_MATRIX[chrome_major]['exact'].include?(driver_version)
      end

      def compatible_match?(chrome_major, driver_version)
        return false unless COMPATIBILITY_MATRIX[chrome_major]
        COMPATIBILITY_MATRIX[chrome_major]['compatible'].include?(driver_version)
      end

      def fallback_match?(chrome_major, driver_version)
        return false unless COMPATIBILITY_MATRIX[chrome_major]
        COMPATIBILITY_MATRIX[chrome_major]['fallback'].include?(driver_version)
      end

      def successful_in_history?(chrome_version, driver_version)
        history = load_success_history
        chrome_key = normalize_version(chrome_version)
        driver_key = normalize_version(driver_version)
        
        return false unless history[chrome_key]&.[](driver_key)
        
        stats = history[chrome_key][driver_key]
        stats['success'] > stats['failure']
      end

      def normalize_version(version)
        version.to_s.split('.')[0..2].join('.')
      end

      def load_success_history
        JSON.parse(File.read(SUCCESS_HISTORY_FILE))
      rescue JSON::ParserError, Errno::ENOENT
        {}
      end

      def save_success_history(history)
        FileUtils.mkdir_p(File.dirname(SUCCESS_HISTORY_FILE))
        File.write(SUCCESS_HISTORY_FILE, JSON.pretty_generate(history))
      end
    end
  end
end
