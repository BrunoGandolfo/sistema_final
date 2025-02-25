class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  helper_method :current_user

  private

  def current_user
    @current_user ||= Usuario.find_by(id: session[:user_id])
  end

  def require_full_access
    unless current_user && current_user.has_full_access?
      respond_to do |format|
        format.json { render json: { error: "Acceso no autorizado" }, status: :forbidden }
        format.html { redirect_to root_path, alert: "Acceso no autorizado" }
      end
    end
  end

  def authenticate_user!
    unless current_user
      respond_to do |format|
        format.json { render json: { error: "Usuario no autenticado" }, status: :unauthorized }
        format.html { redirect_to new_user_session_path, alert: "Debes iniciar sesión" }
      end
    end
  end
end
