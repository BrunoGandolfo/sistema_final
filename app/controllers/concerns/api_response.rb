# app/controllers/concerns/api_response.rb
module ApiResponse
  extend ActiveSupport::Concern

  def json_success(message, data = nil, status = :ok)
    render json: { status: 'success', message: message, data: data }, status: status
  end

  def json_error(message, errors = nil, status = :unprocessable_entity)
    render json: { status: 'error', message: message, errors: errors || [message] }, status: status
  end

  def json_unauthorized
    json_error("Usuario no autenticado", ["Usuario no autenticado"], :unauthorized)
  end

  def json_forbidden
    json_error("Acceso no autorizado", ["Acceso no autorizado"], :forbidden)
  end
end
