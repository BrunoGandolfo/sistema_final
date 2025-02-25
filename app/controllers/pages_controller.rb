class PagesController < ApplicationController
  # Forzamos la autenticación en la página de inicio.
  # Esto redirige automáticamente a la página de login si el usuario no está autenticado.
  before_action :authenticate_user!

  def home
    # Si el usuario ya está autenticado, lo redirige al dashboard.
    redirect_to dashboard_path if current_user
    # Este código no se ejecutará si el usuario no está autenticado,
    # porque 'authenticate_user!' ya redirige al login.
    @user = Usuario.new
  end
end
