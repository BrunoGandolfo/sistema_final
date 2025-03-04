class RegistrationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]
  
  def new
    @usuario = Usuario.new
  end
  
  def create
    # Logs para diagnóstico
    Rails.logger.debug "Formato solicitado: #{request.format.inspect}"
    Rails.logger.debug "Content-Type: #{request.headers['Content-Type']}"
    Rails.logger.debug "Accept: #{request.headers['Accept']}"
    Rails.logger.debug "Parámetros recibidos: #{params.inspect}"
    
    # Detectar de manera más robusta si es una solicitud API
    is_api_request = request.format.json? || 
                    request.headers['Accept']&.include?('application/json') || 
                    Rails.env.test? && request.headers['HTTP_ACCEPT'] != 'text/html'
    
    user = Usuario.new(user_params.merge(rol: "colaborador"))
    
    if user.save
      session[:user_id] = user.id
      
      if is_api_request
        render json: {
          message: 'Usuario registrado exitosamente',
          user: user.as_json(except: [:password_digest])
        }, status: :created
      else
        redirect_to dashboard_path, notice: 'Usuario registrado exitosamente'
      end
    else
      Rails.logger.debug "Errores: #{user.errors.full_messages}"
      
      if is_api_request
        render json: {
          errors: user.errors.full_messages
        }, status: :unprocessable_entity
      else
        flash.now[:alert] = 'Error al registrar usuario'
        render :new, status: :unprocessable_entity
      end
    end
  end
  
  private
  def user_params
    # Intentar primero con parámetros anidados, luego con directos
    if params[:usuario].present?
      params.require(:usuario).permit(:nombre, :email, :password, :password_confirmation)
    else
      params.permit(:nombre, :email, :password, :password_confirmation)
    end
  end
end
