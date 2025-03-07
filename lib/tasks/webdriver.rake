require 'colorize'
require 'fileutils'
require 'open-uri'
require 'zip'
require 'net/http'

namespace :webdriver do
  desc 'Verifica la compatibilidad entre Chrome y ChromeDriver'
  task verify_compatibility: :environment do
    require 'test_infrastructure/driver_compatibility'
    require 'test_infrastructure/driver_config'
    
    puts "=== Verificación de Compatibilidad Chrome/ChromeDriver ===".yellow.bold
    
    # Obtener versión de Chrome
    chrome_version = TestInfrastructure::DriverConfig.chrome_version
    puts "Chrome detectado: #{chrome_version}".cyan
    chrome_major = TestInfrastructure::DriverCompatibility.extract_major_version(chrome_version)
    puts "Versión mayor: #{chrome_major}".cyan
    
    # Obtener drivers disponibles
    drivers = TestInfrastructure::DriverCompatibility.available_drivers
    if drivers.empty?
      puts "No se encontraron drivers disponibles".red.bold
      exit 1
    end
    
    puts "\nDrivers disponibles:".yellow
    drivers.each do |driver|
      driver_version = get_driver_version(driver)
      puts "  - #{File.basename(driver)}: #{driver_version || 'Versión desconocida'}".cyan
    end
    
    # Encontrar el mejor driver
    best_driver = TestInfrastructure::DriverCompatibility.find_best_driver(chrome_version, drivers)
    
    if best_driver
      best_driver_version = get_driver_version(best_driver)
      compatible = TestInfrastructure::DriverCompatibility.compatible?(chrome_version, best_driver_version)
      
      puts "\nMejor driver encontrado:".yellow
      puts "  Ruta: #{best_driver}".cyan
      puts "  Versión: #{best_driver_version || 'Desconocida'}".cyan
      
      if compatible
        puts "  Estado: COMPATIBLE ✓".green
      else
        puts "  Estado: POSIBLE INCOMPATIBILIDAD ⚠".yellow
        puts "  Versiones compatibles con Chrome #{chrome_major}:".yellow
        TestInfrastructure::DriverCompatibility::COMPATIBILITY_MATRIX[chrome_major]['exact'].each do |v|
          puts "    - #{v} (exacta)".cyan
        end
        TestInfrastructure::DriverCompatibility::COMPATIBILITY_MATRIX[chrome_major]['compatible'].each do |v|
          puts "    - #{v} (compatible)".cyan
        end
      end
      
      # Actualizar symlink al mejor driver
      update_symlink(best_driver)
    else
      puts "\nNo se encontró ningún driver compatible".red
      puts "Se requiere descargar un driver compatible con Chrome #{chrome_major}".yellow
      suggest_download_urls(chrome_major)
      exit 1
    end
    
    puts "\n=== Verificación completada ===".green
  end

  desc 'Descarga una versión específica de ChromeDriver'
  task :download, [:version] => :environment do |t, args|
    version = args[:version]
    
    if version.nil? || version.empty?
      puts "Error: Debe especificar una versión".red
      puts "Uso: rake webdriver:download[133.0.6943.0]".yellow
      exit 1
    end
    
    download_driver(version)
  end

  desc 'Gestiona el caché de ChromeDriver'
  task :cache => :environment do |t, args|
    require 'test_infrastructure/driver_cache'
    require 'test_infrastructure/driver_compatibility'
    
    puts "=== Gestión de Caché de ChromeDriver ===".yellow.bold
    
    # Verificar directorio de caché
    cache_dir = TestInfrastructure::DriverCache::CACHE_DIR
    FileUtils.mkdir_p(cache_dir)
    
    # Listar drivers disponibles
    drivers = Dir.glob(File.join(TestInfrastructure::DriverCompatibility::DRIVER_BASE_PATH, 'chromedriver*'))
      .select { |f| File.file?(f) && File.executable?(f) }
    
    if drivers.empty?
      puts "No se encontraron drivers para cachear".red
      exit 1
    end
    
    puts "\nDrivers disponibles para cachear:".yellow
    drivers.each do |driver|
      version = get_driver_version(driver)
      if version
        puts "  - #{File.basename(driver)}: #{version}".cyan
        
        # Leer el binario
        binary_data = File.binread(driver)
        
        # Almacenar en caché
        begin
          cached_path = TestInfrastructure::DriverCache.store_driver(version, binary_data)
          puts "    ✓ Cacheado en: #{cached_path}".green
        rescue => e
          puts "    ✗ Error al cachear: #{e.message}".red
        end
      end
    end
    
    # Mostrar estadísticas del caché
    metadata = TestInfrastructure::DriverCache.send(:load_metadata)
    versions = metadata['versions'] || []
    
    puts "\nEstadísticas del caché:".yellow
    puts "  - Versiones en caché: #{versions.count}".cyan
    puts "  - Versiones disponibles: #{versions.join(', ')}".cyan
    
    # Calcular espacio usado
    total_size = Dir.glob(File.join(cache_dir, '*'))
      .sum { |f| File.size(f) }
    
    puts "  - Espacio total usado: #{(total_size.to_f / 1024 / 1024).round(2)} MB".cyan
    
    puts "\n=== Gestión de Caché Completada ===".green
  end

  desc 'Limpia el caché de ChromeDriver'
  task :clean_cache => :environment do
    require 'test_infrastructure/driver_cache'
    
    puts "=== Limpieza de Caché de ChromeDriver ===".yellow.bold
    
    cache_dir = TestInfrastructure::DriverCache::CACHE_DIR
    if Dir.exist?(cache_dir)
      # Hacer backup del metadata
      metadata_file = TestInfrastructure::DriverCache::METADATA_FILE
      metadata_backup = nil
      if File.exist?(metadata_file)
        metadata_backup = File.read(metadata_file)
      end
      
      # Limpiar directorio
      FileUtils.rm_rf(cache_dir)
      FileUtils.mkdir_p(cache_dir)
      
      # Restaurar metadata
      if metadata_backup
        File.write(metadata_file, metadata_backup)
      end
      
      puts "Caché limpiado correctamente".green
    else
      puts "El directorio de caché no existe".yellow
    end
    
    puts "=== Limpieza Completada ===".green
  end
  
  private
  
  def get_driver_version(driver_path)
    output = `"#{driver_path}" --version 2>/dev/null`
    if output && !output.empty?
      match = output.strip.scan(/[\d]+\.[\d]+\.[\d]+\.[\d]+/).first
      return match if match
    end
    nil
  end
  
  def update_symlink(driver_path)
    target_symlink = File.join(TestInfrastructure::DriverCompatibility::DRIVER_BASE_PATH, 'chromedriver')
    
    # Eliminar symlink existente si existe
    FileUtils.rm_f(target_symlink) if File.exist?(target_symlink)
    
    # Crear nuevo symlink
    FileUtils.ln_sf(driver_path, target_symlink)
    puts "Symlink actualizado: #{target_symlink} -> #{driver_path}".green
  end
  
  def suggest_download_urls(chrome_major)
    puts "\nURLs sugeridas para descarga:".yellow
    
    case chrome_major
    when "133"
      puts "  https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/133.0.6943.0/linux64/chromedriver-linux64.zip".cyan
      puts "  https://chromedriver.storage.googleapis.com/133.0.6943.0/chromedriver_linux64.zip".cyan
    when "134"
      puts "  https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/134.0.6998.0/linux64/chromedriver-linux64.zip".cyan
      puts "  https://chromedriver.storage.googleapis.com/134.0.6998.0/chromedriver_linux64.zip".cyan
    else
      puts "  Buscar en: https://googlechromelabs.github.io/chrome-for-testing/".cyan
    end
    
    puts "\nPara descargar automáticamente:".yellow
    puts "  rake webdriver:download[#{chrome_major}.0.xxxx.0]".cyan
  end
  
  def download_file(url, target_file)
    uri = URI(url)
    
    # Configurar el cliente HTTP con opciones de SSL
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.read_timeout = 30
    
    # Realizar la solicitud GET
    request = Net::HTTP::Get.new(uri)
    response = http.request(request)
    
    case response
    when Net::HTTPSuccess
      File.binwrite(target_file, response.body)
      true
    else
      puts "Error HTTP: #{response.code} #{response.message}".red
      false
    end
  rescue => e
    puts "Error al descargar: #{e.message}".red
    false
  end
  
  def download_driver(version)
    target_dir = TestInfrastructure::DriverCompatibility::DRIVER_BASE_PATH
    target_file = File.join(target_dir, "chromedriver_#{version}")
    temp_zip = File.join(target_dir, "chromedriver_#{version}.zip")
    
    # Crear directorio si no existe
    FileUtils.mkdir_p(target_dir)
    
    # URLs potenciales para descarga
    urls = [
      "https://storage.googleapis.com/chrome-for-testing-public/#{version}/linux64/chromedriver-linux64.zip",
      "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/#{version}/linux64/chromedriver-linux64.zip",
      "https://chromedriver.storage.googleapis.com/#{version}/chromedriver_linux64.zip"
    ]
    
    # Intentar cada URL
    download_success = false
    
    urls.each do |url|
      puts "Intentando descargar desde: #{url}".cyan
      
      if download_file(url, temp_zip)
        download_success = true
        puts "Descarga exitosa".green
        break
      end
    end
    
    unless download_success
      puts "No se pudo descargar ChromeDriver #{version} desde ninguna fuente".red.bold
      exit 1
    end
    
    # Extraer archivo zip
    puts "Extrayendo archivo...".cyan
    
    begin
      Zip::File.open(temp_zip) do |zip|
        # Buscar el ejecutable chromedriver dentro del zip (incluyendo subdirectorios)
        entry = zip.entries.find { |e| 
          e.name.end_with?('/chromedriver') || # Para el nuevo formato
          e.name == 'chromedriver' || # Para el formato antiguo
          e.name.end_with?('/chromedriver.exe') || 
          e.name == 'chromedriver.exe'
        }
        
        if entry
          puts "Extrayendo: #{entry.name} -> #{target_file}".cyan
          
          # Asegurarse de que el directorio destino existe
          FileUtils.mkdir_p(File.dirname(target_file))
          
          # Extraer y sobrescribir si existe
          entry.extract(target_file) { true }
          
          # Hacer ejecutable
          FileUtils.chmod(0755, target_file)
          puts "Permisos establecidos correctamente".green
        else
          puts "No se encontró el ejecutable chromedriver en el archivo zip".red
          puts "Contenido del zip:".yellow
          zip.entries.each do |e|
            puts "  - #{e.name}".cyan
          end
          exit 1
        end
      end
      
      # Limpiar archivo temporal
      FileUtils.rm_f(temp_zip)
      puts "Archivo temporal eliminado".green
      
    rescue => e
      puts "Error al extraer archivo: #{e.message}".red
      FileUtils.rm_f(temp_zip)
      exit 1
    end
    
    # Verificar instalación
    if File.exist?(target_file) && File.executable?(target_file)
      puts "ChromeDriver #{version} instalado correctamente en: #{target_file}".green
      
      # Almacenar en caché
      begin
        binary_data = File.binread(target_file)
        TestInfrastructure::DriverCache.store_driver(version, binary_data)
        puts "Driver almacenado en caché".green
      rescue => e
        puts "Advertencia: No se pudo cachear el driver: #{e.message}".yellow
      end
      
      # Actualizar symlink
      update_symlink(target_file)
      
      # Mostrar versión instalada
      installed_version = get_driver_version(target_file)
      puts "Versión instalada: #{installed_version}".green
    else
      puts "Error al instalar ChromeDriver".red
      exit 1
    end
  end
end
