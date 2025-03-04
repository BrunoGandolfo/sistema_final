# app/controllers/distribucion_utilidades_controller.rb

class DistribucionUtilidadesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_full_access, only: :create

  def create
    @distribucion_utilidad = DistribucionUtilidad.crear_con_usuario(distribucion_utilidad_params, current_user)

    if @distribucion_utilidad.persisted?
      if api_request?
        json_success('Distribución de utilidades creada correctamente', @distribucion_utilidad, :created)
      else
        redirect_to dashboard_path, notice: 'Distribución registrada con éxito.'
      end
    else
      if api_request?
        json_error('Error al registrar distribución', @distribucion_utilidad.errors.full_messages)
      else
        redirect_to dashboard_path, alert: 'Error al registrar distribución.'
      end
    end
  end

  private

  def distribucion_utilidad_params
    params.require(:distribucion_utilidad).permit(
      :fecha, :sucursal, :tipo_cambio_id, :tipo_cambio,
      :monto_uyu_agustina, :monto_usd_agustina,
      :monto_uyu_viviana, :monto_usd_viviana,
      :monto_uyu_gonzalo, :monto_usd_gonzalo,
      :monto_uyu_pancho, :monto_usd_pancho,
      :monto_uyu_bruno, :monto_usd_bruno
    )
  end
end
