module TestInfrastructure
  class DriverRegistry
    # Mapeo de compatibilidad Chrome/ChromeDriver
    CHROME_COMPATIBILITY = {
      # Chrome 133.x es compatible con ChromeDriver 133.x y 134.x
      '133' => ['133.0.6943', '134.0.6998'],
      # Chrome 134.x es compatible con ChromeDriver 134.x
      '134' => ['134.0.6998']
    }
    
    # Determina si una combinación específica es compatible
    def self.compatible?(browser_version, driver_version)
      major_browser = browser_version.to_s.split('.').first
      driver_base = driver_version.to_s.split('.')[0..2].join('.')
      
      return false unless CHROME_COMPATIBILITY[major_browser]
      CHROME_COMPATIBILITY[major_browser].include?(driver_base)
    end
    
    # Encuentra el mejor driver disponible para una versión de browser
    def self.find_best_driver(browser_version, available_drivers)
      major_browser = browser_version.to_s.split('.').first
      return nil unless CHROME_COMPATIBILITY[major_browser]
      
      # Intentar encontrar el driver más cercano a la versión del browser
      CHROME_COMPATIBILITY[major_browser].each do |driver_base|
        available_drivers.each do |driver_path|
          return driver_path if driver_path.include?(driver_base)
        end
      end
      
      # Si no hay match exacto, devolver cualquier driver disponible
      available_drivers.first
    end
  end
end
