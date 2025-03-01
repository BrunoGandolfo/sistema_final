class IngresosController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @ingreso = Ingreso.crear_con_usuario(ingreso_params, current_user)
    respond_to do |format|
      if @ingreso.persisted?
        format.html { redirect_to dashboard_path, notice: 'Ingreso registrado con éxito.' }
        format.json { render json: { status: 'success', message: 'Ingreso registrado con éxito' }, status: :created }
      else
        format.html { redirect_to dashboard_path, alert: 'Error al registrar ingreso.' }
        format.json { render json: { status: 'error', errors: @ingreso.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end
  
  private
  
  def ingreso_params
    params.require(:ingreso).permit(:fecha, :concepto, :monto, :moneda, :area, :cliente_id, :sucursal, :tipo_cambio_id)
  end
end
