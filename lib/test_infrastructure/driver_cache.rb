module TestInfrastructure
  class DriverCache
    CACHE_DIR = Rails.root.join('vendor', 'webdrivers', 'cache')
    METADATA_FILE = CACHE_DIR.join('metadata.json')

    class << self
      def store_driver(version, binary_data)
        ensure_cache_directory
        
        # Almacenar versión original completa
        full_path = driver_path(version)
        File.binwrite(full_path, binary_data)
        
        # Generar y almacenar deltas para versiones relacionadas
        store_deltas(version, binary_data)
        
        # Actualizar metadata
        update_metadata(version)
        
        full_path
      end
      
      def retrieve_driver(version)
        # Verificar si tenemos la versión exacta
        exact_path = driver_path(version)
        return exact_path if File.exist?(exact_path)
        
        # Intentar reconstruir desde delta si existe
        reconstructed = reconstruct_from_delta(version)
        return reconstructed if reconstructed
        
        # No hay versión ni delta disponible
        nil
      end

      private

      def ensure_cache_directory
        FileUtils.mkdir_p(CACHE_DIR)
        FileUtils.touch(METADATA_FILE) unless File.exist?(METADATA_FILE)
      end

      def driver_path(version)
        CACHE_DIR.join("chromedriver_#{version}")
      end

      def delta_path(source_version, target_version)
        CACHE_DIR.join("delta_#{source_version}_to_#{target_version}")
      end

      def store_deltas(version, binary_data)
        # Obtener versiones cercanas para generar deltas
        nearby_versions.each do |existing_version|
          next if existing_version == version
          
          if version_proximity(version, existing_version) <= 2
            delta = binary_delta(retrieve_driver(existing_version), binary_data)
            delta_path = delta_path(existing_version, version)
            File.binwrite(delta_path, delta)
          end
        end
      end

      def nearby_versions
        metadata = load_metadata
        metadata['versions'] || []
      end

      def version_proximity(version1, version2)
        v1_parts = version1.split('.')
        v2_parts = version2.split('.')
        
        # Comparar solo versiones mayores y menores
        (v1_parts[0].to_i - v2_parts[0].to_i).abs + 
        (v1_parts[1].to_i - v2_parts[1].to_i).abs
      end

      def binary_delta(source_data, target_data)
        # Implementación simple de delta binario
        require 'diff/lcs'
        Diff::LCS.diff(source_data.bytes, target_data.bytes).to_json
      end

      def apply_delta(source_data, delta)
        # Aplicar delta para reconstruir el binario
        require 'diff/lcs'
        changes = JSON.parse(delta)
        result = source_data.bytes.dup
        
        changes.each do |change|
          case change['action']
          when 'delete'
            result.slice!(change['position'])
          when 'insert'
            result.insert(change['position'], change['element'])
          end
        end
        
        result.pack('C*')
      end

      def load_metadata
        JSON.parse(File.read(METADATA_FILE))
      rescue JSON::ParserError, Errno::ENOENT
        { 'versions' => [] }
      end

      def update_metadata(version)
        metadata = load_metadata
        metadata['versions'] ||= []
        metadata['versions'] << version unless metadata['versions'].include?(version)
        File.write(METADATA_FILE, JSON.pretty_generate(metadata))
      end
    end
  end
end
