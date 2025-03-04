FactoryBot.define do
  factory :ingreso do
    association :usuario
    association :cliente
    association :tipo_cambio
    monto { 1000.00 }
    moneda { "UYU" }
    fecha { Date.today }
    sucursal { "Montevideo" }
    area { "Contable" }
    concepto { "Factura por servicios" }
  end
end
