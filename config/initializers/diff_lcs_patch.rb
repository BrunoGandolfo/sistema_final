# Archivo: config/initializers/diff_lcs_patch.rb
#
# Este parche se implementa para solucionar el error "undefined method `ignored?'" 
# causado por la gema diff-lcs en Ruby 3.2. Algunas gemas (como diff-lcs) pueden requerir 
# el método `ignored?`, que no está definido en la versión 1.6.0.
#
# NOTA IMPORTANTE:
# - Esta solución es temporal y debe ser removida una vez que el problema se solucione en 
#   una versión oficial de la gema diff-lcs.
# - Se recomienda reportar el issue en el repositorio de diff-lcs y documentar el parche 
#   para que otros desarrolladores entiendan el motivo del mismo.

if !Gem::Specification.method_defined?(:ignored?)
  class Gem::Specification
    # Define el método 'ignored?' que retorna false por defecto.
    # Esto evita que se lance el error de método no definido durante la ejecución de tests o tareas.
    def ignored?
      false
    end
  end
end
