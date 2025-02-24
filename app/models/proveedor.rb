class Proveedor < ApplicationRecord
  validates :nombre, presence: true
end
