class DistribucionUtilidadesController < ApplicationController
  def create
    @distribucion = DistribucionUtilidad.new(distribucion_utilidad_params)
    if @distribucion.save
      render json: { message: "Distribución de Utilidad creada correctamente" }, status: :created
    else
      render json: { errors: @distribucion.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def distribucion_utilidad_params
    params.require(:distribucion_utilidad).permit(
      :fecha,
      :tipo_cambio,
      :sucursal,
      :monto_uyu_agustina,
      :monto_usd_agustina,
      :monto_uyu_viviana,
      :monto_usd_viviana,
      :monto_uyu_gonzalo,
      :monto_usd_gonzalo,
      :monto_uyu_pancho,
      :monto_usd_pancho,
      :monto_uyu_bruno,
      :monto_usd_bruno
    )
  end
end
