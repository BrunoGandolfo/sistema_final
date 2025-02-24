class PagesController < ApplicationController
  # Si no necesitas forzar autenticación en la página de inicio, puedes omitir este callback.
  # Si usas un método de autenticación básico, asegúrate de que esté definido en ApplicationController.

  def home
    # Si ya hay un usuario autenticado, redirige al dashboard.
    redirect_to dashboard_path if current_user
    # Prepara un nuevo usuario para el formulario de registro.
@user = Usuario.new
  end
end
