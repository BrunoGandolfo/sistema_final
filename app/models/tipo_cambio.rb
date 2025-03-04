class TipoCambio < ApplicationRecord
  self.table_name = "tipos_cambio"

  # Relaciones con otros modelos
  has_many :ingresos
  has_many :gastos
  has_many :distribuciones_utilidades, class_name: 'DistribucionUtilidad'
  has_many :retiros_utilidades, class_name: 'RetiroUtilidad'

  # Validaciones
  validates :moneda, presence: true
  validates :valor, presence: true, numericality: { greater_than: 0 }
  validates :fecha, presence: true

  # Método para obtener el tipo de cambio más reciente (Modelo Gordo)
  def self.mas_reciente(moneda = 'USD')
    where(moneda: moneda).order(fecha: :desc).first
  end

  # Método para obtener el valor del tipo de cambio más reciente
  def self.valor_actual(moneda = 'USD')
    tipo_cambio = mas_reciente(moneda)
    tipo_cambio ? tipo_cambio.valor : nil
  end
end
