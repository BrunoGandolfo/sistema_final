class Cliente < ApplicationRecord
  validates :nombre, presence: true
end
