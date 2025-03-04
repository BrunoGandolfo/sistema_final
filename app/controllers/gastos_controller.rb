# app/controllers/gastos_controller.rb

class GastosController < ApplicationController
  before_action :authenticate_user!

  def create
    @gasto = Gasto.crear_con_usuario(gasto_params, current_user)

    if @gasto.persisted?
      if api_request?
        json_success('Gasto creado correctamente', @gasto, :created)
      else
        redirect_to dashboard_path, notice: 'Gasto registrado con éxito.'
      end
    else
      if api_request?
        json_error('Error al registrar gasto', @gasto.errors.full_messages)
      else
        redirect_to dashboard_path, alert: "Error al registrar gasto: #{@gasto.errors.full_messages.join(', ')}"
      end
    end
  end

  private

  def gasto_params
    params.require(:gasto).permit(:fecha, :concepto, :monto, :moneda, :area, :proveedor_id, :sucursal, :tipo_cambio_id)
  end
end
