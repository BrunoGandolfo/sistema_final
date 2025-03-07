module EnhancedDebugging
  def self.setup_directories
    %w[screenshots debug logs].each do |dir|
      FileUtils.mkdir_p(Rails.root.join('tmp', dir))
    end
  end

  def self.save_debug_info(page, example)
    return unless example.exception

    timestamp = Time.current.strftime('%Y%m%d%H%M%S')
    base_name = "#{timestamp}_#{example.description.gsub(/[^0-9A-Za-z]/, '_')}"

    save_screenshot(page, base_name)
    save_html(page, base_name)
    save_browser_logs(page, base_name)
  end

  private

  def self.save_screenshot(page, base_name)
    screenshot_path = Rails.root.join('tmp', 'screenshots', "#{base_name}.png")
    page.save_screenshot(screenshot_path.to_s)
    Rails.logger.info "Screenshot guardado en: #{screenshot_path}"
  rescue => e
    Rails.logger.warn "Error guardando screenshot: #{e.message}"
  end

  def self.save_html(page, base_name)
    html_path = Rails.root.join('tmp', 'debug', "#{base_name}.html")
    File.write(html_path, page.html)
    Rails.logger.info "HTML guardado en: #{html_path}"
  rescue => e
    Rails.logger.warn "Error guardando HTML: #{e.message}"
  end

  def self.save_browser_logs(page, base_name)
    return unless page.driver.browser.respond_to?(:logs)

    begin
      logs = page.driver.browser.logs.get(:browser)
      logs_path = Rails.root.join('tmp', 'logs', "#{base_name}_browser.log")
      File.write(logs_path, logs.join("\n"))
      Rails.logger.info "Logs del navegador guardados en: #{logs_path}"
    rescue => e
      Rails.logger.warn "No se pudieron obtener logs del navegador: #{e.message}"
    end
  end

  def save_browser_logs
    return unless page.driver.browser.respond_to?(:logs)
    
    timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
    logs_path = Rails.root.join('tmp', 'browser_logs', "#{timestamp}_browser.log").to_s
    
    FileUtils.mkdir_p(File.dirname(logs_path))
    
    logs = page.driver.browser.logs.get(:browser)
    File.write(logs_path, logs.map(&:message).join("\n"))
  rescue => e
    puts "Error al guardar logs del navegador: #{e.message}"
  end

  def save_page_screenshot(example)
    return unless page.current_window.handle.present?

    timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
    filename = "#{timestamp}_#{example.description.gsub(/\s+/, '_').gsub(/[^0-9A-Za-z_]/, '')}"
    
    screenshots_dir = Rails.root.join('tmp', 'screenshots').to_s
    FileUtils.mkdir_p(screenshots_dir)
    
    screenshot_path = File.join(screenshots_dir, "#{filename}.png")
    html_path = File.join(screenshots_dir, "#{filename}.html")
    
    begin
      page.save_screenshot(screenshot_path)
      puts "\nScreenshot guardado: #{screenshot_path}"
      
      File.write(html_path, page.html)
      puts "HTML guardado: #{html_path}"
    rescue => e
      puts "Error al guardar evidencia: #{e.message}"
    end
  end
end

RSpec.configure do |config|
  config.before(:suite) do
    EnhancedDebugging.setup_directories
  end

  config.after(:each, type: :system) do |example|
    if example.exception
      EnhancedDebugging.save_debug_info(page, example)
      EnhancedDebugging.save_browser_logs
      EnhancedDebugging.save_page_screenshot(example)
    end
  end
end 