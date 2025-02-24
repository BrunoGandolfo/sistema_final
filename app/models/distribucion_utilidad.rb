class DistribucionUtilidad < ApplicationRecord

  # Validaciones obligatorias
  validates :fecha, presence: true
  validates :tipo_cambio, presence: true, numericality: { greater_than: 0 }
  validates :sucursal, presence: true

  # Validaciones opcionales para los montos de cada socio
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
end
