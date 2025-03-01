FactoryBot.define do
  factory :retiro_utilidad do
    fecha { Date.today }
    association :tipo_cambio
    monto_uyu { 50000.00 }     # Cambiado de monto_pesos
    monto_usd { nil }          # Cambiado de monto_dolares
    sucursal { "montevideo" }  # Cambiado de localidad
    association :usuario
  end
end
