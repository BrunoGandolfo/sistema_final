FactoryBot.define do
  factory :gasto do
    association :usuario
    association :proveedor
    association :tipo_cambio
    monto { 500.00 }
    moneda { "UYU" }
    fecha { Date.today }
    sucursal { "Montevideo" }
    area { "Gastos Generales" }
    concepto { "Compra de materiales" }
  end
end
