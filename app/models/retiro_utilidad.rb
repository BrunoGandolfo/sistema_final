class RetiroUtilidad < ApplicationRecord

  # Validaciones obligatorias
  validates :fecha, presence: true
  validates :tipo_cambio, presence: true, numericality: { greater_than: 0 }
  validates :sucursal, presence: true

  # Validaciones opcionales para los montos
  validates :monto_uyu, numericality: true, allow_nil: true
  validates :monto_usd, numericality: true, allow_nil: true
end
