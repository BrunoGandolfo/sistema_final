class Gasto < ApplicationRecord
  # Asociaciones
  belongs_to :usuario
  belongs_to :proveedor
  belongs_to :tipo_cambio
  # Validaciones
  validates :monto, presence: true, numericality: { greater_than: 0 }
  validates :moneda, presence: true, inclusion: { in: ['USD', 'UYU'] }
  validates :fecha, presence: true
  validates :sucursal, presence: true
  validates :area, presence: true
  validates :concepto, presence: true
  
  # Método de clase para crear con usuario
  def self.crear_con_usuario(params, current_user)
    gasto = new(params)
    gasto.usuario = current_user if current_user
    gasto.save
    gasto
  end
end
