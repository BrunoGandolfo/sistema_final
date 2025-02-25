class Cliente < ApplicationRecord
  has_many :ingresos  # Esta asociación centraliza la lógica de relación con ingresos
  validates :nombre, presence: true
end
