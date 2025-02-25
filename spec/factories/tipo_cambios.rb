FactoryBot.define do
  factory :tipo_cambio do
    moneda { "USD" }   # Asigna un valor predeterminado; ajusta si es necesario
    valor { 1.0 }
    fecha { Date.today }
  end
end
