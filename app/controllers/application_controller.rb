class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  def current_user
    @current_user ||= Usuario.find_by(id: session[:user_id])
  end

  def require_full_access
    unless current_user && current_user.has_full_access?
      render json: { error: "Acceso no autorizado" }, status: :forbidden
    end
  end

  # Nuevo método para autenticar al usuario y redirigirlo a login si no está autenticado
  def authenticate_user!
    unless current_user
      redirect_to new_user_session_path
    end
  end
end
