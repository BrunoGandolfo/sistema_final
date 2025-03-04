class DistribucionUtilidad < ApplicationRecord
  # Relaciones con usuario y tipo de cambio
  belongs_to :usuario, optional: true
  belongs_to :tipo_cambio
  # Validaciones obligatorias
  validates :fecha, presence: true
  validates :sucursal, presence: true
  # Validaciones para los montos (permiten nil, pero si se ingresan deben ser numéricos)
  validates :monto_uyu_agustina, numericality: true, allow_nil: true
  validates :monto_usd_agustina, numericality: true, allow_nil: true
  validates :monto_uyu_viviana, numericality: true, allow_nil: true
  validates :monto_usd_viviana, numericality: true, allow_nil: true
  validates :monto_uyu_gonzalo, numericality: true, allow_nil: true
  validates :monto_usd_gonzalo, numericality: true, allow_nil: true
  validates :monto_uyu_pancho, numericality: true, allow_nil: true
  validates :monto_usd_pancho, numericality: true, allow_nil: true
  validates :monto_uyu_bruno, numericality: true, allow_nil: true
  validates :monto_usd_bruno, numericality: true, allow_nil: true
  # Método de clase para crear el registro asociado a un usuario (Modelo Gordo)
  def self.crear_con_usuario(params, current_user)
    # Buscar o crear el TipoCambio según el valor recibido
    tipo_cambio_id = if params[:tipo_cambio_id].present?
                        params[:tipo_cambio_id]
                      elsif params[:tipo_cambio].present?
                        tipo_cambio = TipoCambio.find_or_create_by(
                          moneda: 'USD',
                          valor: params[:tipo_cambio]
                        ) do |tc|
                          tc.fecha = Date.today
                        end
                        tipo_cambio.id
                      end
    # Crear la distribución con los parámetros normalizados
    distribucion = new(params.except(:tipo_cambio))
    distribucion.tipo_cambio_id = tipo_cambio_id if tipo_cambio_id
    distribucion.usuario = current_user if current_user
    distribucion.save
    distribucion
  end
end
