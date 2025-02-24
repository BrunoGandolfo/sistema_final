require 'rails_helper'

RSpec.describe Gasto, type: :model do
  let!(:usuario) { 
    Usuario.create!(
      nombre: "Usuario Test", 
      email: "test@ejemplo.com", 
      rol: "colaborador", 
      password: "password", 
      password_confirmation: "password"
    ) 
  }
  let(:proveedor) { Proveedor.create!(nombre: "Proveedor Test") }
  let(:tipo_cambio) { TipoCambio.create!(moneda: "USD", valor: 1.0, fecha: Time.current) }

  before do
    usuario
    proveedor
    tipo_cambio
  end

  subject {
    Gasto.new(
      usuario: usuario,
      proveedor: proveedor,
      tipo_cambio: tipo_cambio,
      monto: 150.00,
      moneda: "USD",
      fecha: Time.current,
      sucursal: "Montevideo",
      area: "Contable",
      concepto: "Pago de servicios"
    )
  }

  it "es válido con todos los atributos correctos" do
    expect(subject).to be_valid
  end

  it "no es válido sin monto" do
    subject.monto = nil
    expect(subject).to_not be_valid
  end

  it "no es válido si el monto es menor o igual a 0" do
    subject.monto = 0
    expect(subject).to_not be_valid
  end

  it "no es válido sin moneda" do
    subject.moneda = nil
    expect(subject).to_not be_valid
  end

  it "no es válido con un valor de moneda no permitido" do
    subject.moneda = "EUR"
    expect(subject).to_not be_valid
  end
end
