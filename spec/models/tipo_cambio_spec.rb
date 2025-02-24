require 'rails_helper'

RSpec.describe TipoCambio, type: :model do
  it "es válido con moneda, valor y fecha" do
    tipo_cambio = TipoCambio.new(moneda: "USD", valor: 1.0, fecha: Date.today)
    expect(tipo_cambio).to be_valid
  end
end
