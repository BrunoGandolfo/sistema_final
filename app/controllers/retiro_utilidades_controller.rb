class RetiroUtilidadesController < ApplicationController
  def create
    @retiro = RetiroUtilidad.new(retiro_utilidad_params)
    if @retiro.save
      render json: { message: "Retiro de Utilidad creado correctamente" }, status: :created
    else
      render json: { errors: @retiro.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def retiro_utilidad_params
    params.require(:retiro_utilidad).permit(:fecha, :tipo_cambio, :sucursal, :monto_uyu, :monto_usd)
  end
end
