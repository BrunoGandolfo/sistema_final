class Ingreso < ApplicationRecord
  # Asociaciones
  belongs_to :usuario
  belongs_to :cliente
  belongs_to :tipo_cambio
  
  # Validaciones
  validates :monto, presence: true, numericality: { greater_than: 0 }
  validates :moneda, presence: true, inclusion: { in: ['USD', 'UYU'] }
  validates :fecha, presence: true
  validates :sucursal, presence: true
  validates :area, presence: true
  validates :concepto, presence: true
  
  # Método para facilitar la creación (siguiendo el patrón de "modelos gordos")
  def self.crear_con_usuario(params, current_user)
    ingreso = new(params)
    ingreso.usuario = current_user
    ingreso.save
    ingreso
  end
end
