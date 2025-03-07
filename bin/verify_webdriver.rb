#!/usr/bin/env ruby
require 'webdrivers'
require 'fileutils'

def verify_chromedriver
  puts "\n=== Verificando ChromeDriver ==="
  puts "Versión de Chrome instalada: #{Webdrivers::Chromedriver.browser_version}"
  puts "Versión de ChromeDriver requerida: #{Webdrivers::Chromedriver.required_version}"
  puts "Directorio de instalación: #{Webdrivers.install_dir}"
  
  # Intentar actualizar ChromeDriver
  begin
    Webdrivers::Chromedriver.update
    puts "\n✅ ChromeDriver actualizado exitosamente"
    puts "Ubicación: #{Webdrivers::Chromedriver.driver_path}"
  rescue => e
    puts "\n❌ Error actualizando ChromeDriver:"
    puts e.message
    puts "\nStack trace:"
    puts e.backtrace
    exit 1
  end
  
  # Verificar permisos
  driver_path = Webdrivers::Chromedriver.driver_path
  unless File.executable?(driver_path)
    puts "\n⚠️ Ajustando permisos de ChromeDriver..."
    FileUtils.chmod('+x', driver_path)
  end
  
  puts "\n=== Información del Sistema ==="
  puts "Sistema Operativo: #{RUBY_PLATFORM}"
  puts "Ruby version: #{RUBY_VERSION}"
  puts "Rails version: #{Rails.version}"
  puts "Webdrivers version: #{Webdrivers::VERSION}"
  puts "\n✅ Verificación completada"
end

verify_chromedriver 