module TestInfrastructure
  class NetworkDiagnostics
    CRITICAL_DOMAINS = [
      'chromedriver.storage.googleapis.com',
      'github.com',
      'googlechromelabs.github.io'
    ]
    
    class << self
      def check_connectivity
        results = {}
        
        CRITICAL_DOMAINS.each do |domain|
          results[domain] = can_resolve?(domain)
        end
        
        log_results(results)
        
        results.values.all?
      end
      
      def can_resolve?(domain)
        require 'resolv'
        begin
          Resolv.getaddress(domain)
          true
        rescue Resolv::ResolvError
          false
        end
      end
      
      def log_results(results)
        Rails.logger.info "== Diagnóstico de Red =="
        
        results.each do |domain, resolvable|
          status = resolvable ? 'OK' : 'FALLO'
          Rails.logger.info "  #{domain}: #{status}"
        end
        
        if results.values.all?
          Rails.logger.info "Conectividad de red: OK"
        else
          Rails.logger.warn "Conectividad de red: PROBLEMAS DETECTADOS"
          Rails.logger.warn "Ejecute bin/wsl-dns-fix para reparar problemas de DNS"
        end
      end
    end
  end
end
