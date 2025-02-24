class GastosController < ApplicationController
  def create
    @gasto = Gasto.new(gasto_params)
    if @gasto.save
      render json: { message: "Gasto creado correctamente" }, status: :created
    else
      render json: { errors: @gasto.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def gasto_params
    params.require(:gasto).permit(:usuario_id, :proveedor_id, :tipo_cambio_id, :monto, :moneda, :fecha, :sucursal, :area, :concepto)
  end
end
