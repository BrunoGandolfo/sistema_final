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
end
