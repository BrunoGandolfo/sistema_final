if defined?(Webdrivers)
  # Configuración de caché
  Webdrivers.cache_time = 86_400 # 1 día
  Webdrivers.install_dir = Rails.root.join('tmp', 'webdrivers_cache')

  # Asegurar directorio existente
  FileUtils.mkdir_p(Webdrivers.install_dir)

  # Configurar timeouts más largos para descargas
  Webdrivers::Chromedriver.class_eval do
    def self.download_options
      {
        read_timeout: 120,
        open_timeout: 120,
        ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE
      }
    end
  end

  # Configurar proxy si está definido en el ambiente
  if ENV['HTTP_PROXY']
    Webdrivers.net_http_ssl_fix = true
    uri = URI.parse(ENV['HTTP_PROXY'])
    Webdrivers.proxy_addr = uri.host
    Webdrivers.proxy_port = uri.port
    Webdrivers.proxy_user = uri.user
    Webdrivers.proxy_pass = uri.password
  end

  # Configurar certificados SSL personalizados si existen
  if File.exist?(Rails.root.join('config', 'certs', 'custom.pem'))
    ENV['SSL_CERT_FILE'] = Rails.root.join('config', 'certs', 'custom.pem').to_s
  end

  # Cargar configuración local de WebDriver
  require Rails.root.join('spec', 'support', 'local_webdriver_config')
  LocalWebdriverConfig.configure
end 