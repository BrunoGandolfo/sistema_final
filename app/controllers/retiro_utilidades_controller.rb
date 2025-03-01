class RetiroUtilidadesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @retiro_utilidad = RetiroUtilidad.crear_con_usuario(retiro_utilidad_params, current_user)
    
    respond_to do |format|
      if @retiro_utilidad.persisted?
        format.html { redirect_to dashboard_path, notice: 'Retiro registrado con éxito.' }
        format.json { render json: { status: 'success', message: 'Retiro registrado con éxito' }, status: :created }
      else
        format.html { redirect_to dashboard_path, alert: 'Error al registrar retiro.' }
        format.json { render json: { status: 'error', errors: @retiro_utilidad.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end
  
  private
  def retiro_utilidad_params
    params.require(:retiro_utilidad).permit(:fecha, :monto_uyu, :monto_usd, :sucursal, :tipo_cambio_id, :tipo_cambio)
  end
end
