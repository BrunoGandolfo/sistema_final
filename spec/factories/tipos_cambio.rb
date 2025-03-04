FactoryBot.define do
  factory :tipo_cambio do
    moneda { "USD" }
    valor { 38.50 }
    fecha { Date.today }
  end
end
