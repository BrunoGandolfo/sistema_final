class IngresosController < ApplicationController
  def create
    @ingreso = Ingreso.new(ingreso_params)
    if @ingreso.save
      render json: { message: "Ingreso creado correctamente" }, status: :created
    else
      render json: { errors: @ingreso.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def ingreso_params
    params.require(:ingreso).permit(:usuario_id, :cliente_id, :tipo_cambio_id, :monto, :moneda, :fecha, :sucursal, :area, :concepto)
  end
end
