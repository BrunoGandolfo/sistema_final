class Proveedor < ApplicationRecord
  has_many :gastos
  validates :nombre, presence: true
end
