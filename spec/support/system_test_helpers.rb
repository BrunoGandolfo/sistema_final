module SystemTestHelpers
  # Convertir automáticamente rutas comunes a String
  %i[login_path dashboard_path user_path].each do |method_name|
    define_method(method_name) do |*args|
      super(*args).to_s
    end
  end

  # Helper para debugging que asegura strings en rutas
  def ensure_string_path(path)
    path.respond_to?(:to_s) ? path.to_s : path
  end
end

RSpec.configure do |config|
  config.include SystemTestHelpers, type: :system
end 