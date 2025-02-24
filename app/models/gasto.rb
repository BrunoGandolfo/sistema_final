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
end
