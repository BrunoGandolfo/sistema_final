# app/controllers/ingresos_controller.rb

class IngresosController < ApplicationController
  before_action :authenticate_user!

  def create
    @ingreso = Ingreso.crear_con_usuario(ingreso_params, current_user)

    if @ingreso.persisted?
      if api_request?
        json_success('Ingreso creado correctamente', @ingreso, :created)
      else
        redirect_to dashboard_path, notice: 'Ingreso registrado con éxito.'
      end
    else
      if api_request?
        json_error('Error al registrar ingreso', @ingreso.errors.full_messages)
      else
        redirect_to dashboard_path, alert: 'Error al registrar ingreso.'
      end
    end
  end

  private

  def ingreso_params
    params.require(:ingreso).permit(:fecha, :concepto, :monto, :moneda, :area, :cliente_id, :sucursal, :tipo_cambio_id)
  end
end
