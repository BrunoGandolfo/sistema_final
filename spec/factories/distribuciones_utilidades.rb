FactoryBot.define do
  factory :distribucion_utilidad do
    fecha { Date.today }
    association :tipo_cambio
    sucursal { "montevideo" }      # Cambiado de localidad
    monto_uyu_agustina { 500 }     # Cambiado de monto_pesos_agustina
    monto_usd_agustina { 20 }      # Cambiado de monto_dolares_agustina
    monto_uyu_viviana { 500 }      # Cambiado de monto_pesos_viviana
    monto_usd_viviana { 20 }       # Cambiado de monto_dolares_viviana
    monto_uyu_gonzalo { 500 }      # Cambiado de monto_pesos_gonzalo
    monto_usd_gonzalo { 20 }       # Cambiado de monto_dolares_gonzalo
    monto_uyu_pancho { 500 }       # Cambiado de monto_pesos_pancho
    monto_usd_pancho { 20 }        # Cambiado de monto_dolares_pancho
    monto_uyu_bruno { 500 }        # Cambiado de monto_pesos_bruno
    monto_usd_bruno { 20 }         # Cambiado de monto_dolares_bruno
    association :usuario
  end
end
