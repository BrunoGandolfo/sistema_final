class RetiroUtilidad < ApplicationRecord
  # Relaciona el retiro con el usuario y el tipo de cambio
  belongs_to :usuario, optional: true
  belongs_to :tipo_cambio
  # Validaciones obligatorias
  validates :fecha, presence: true
  validates :sucursal, presence: true
  # Validaciones para los montos (permiten nil, pero si se ingresa, debe ser numérico)
  validates :monto_uyu, numericality: true, allow_nil: true
  validates :monto_usd, numericality: true, allow_nil: true
  # Método de clase para crear el registro asociado a un usuario (Modelo Gordo)
  def self.crear_con_usuario(params, current_user)
    # Si se proporciona un valor para el tipo de cambio como parámetro, se busca o crea el registro
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
    # Crear el objeto sin el parámetro 'tipo_cambio' si éste se encuentra en params
    retiro = new(params.except(:tipo_cambio))
    retiro.tipo_cambio_id = tipo_cambio_id if tipo_cambio_id
    retiro.usuario = current_user if current_user
    retiro.save
    retiro
  end
end
