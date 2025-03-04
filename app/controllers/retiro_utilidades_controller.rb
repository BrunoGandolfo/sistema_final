# app/controllers/retiro_utilidades_controller.rb

class RetiroUtilidadesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_full_access, only: :create

  def create
    @retiro_utilidad = RetiroUtilidad.crear_con_usuario(retiro_utilidad_params, current_user)

    if @retiro_utilidad.persisted?
      if api_request?
        json_success('Retiro de utilidad creado correctamente', @retiro_utilidad, :created)
      else
        redirect_to dashboard_path, notice: 'Retiro registrado con éxito.'
      end
    else
      if api_request?
        json_error('Error al registrar retiro', @retiro_utilidad.errors.full_messages)
      else
        redirect_to dashboard_path, alert: 'Error al registrar retiro.'
      end
    end
  end

  private

  def retiro_utilidad_params
    params.require(:retiro_utilidad).permit(:fecha, :monto_uyu, :monto_usd, :sucursal, :tipo_cambio_id, :tipo_cambio)
  end
end
