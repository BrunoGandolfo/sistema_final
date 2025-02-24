require 'rails_helper'

RSpec.describe DistribucionUtilidad, type: :model do
  subject {
    DistribucionUtilidad.new(
      fecha: Time.current,
      tipo_cambio: 1.23,
      sucursal: "Montevideo",
      monto_uyu_agustina: 100.0,
      monto_usd_agustina: 50.0,
      monto_uyu_viviana: 100.0,
      monto_usd_viviana: 50.0,
      monto_uyu_gonzalo: 100.0,
      monto_usd_gonzalo: 50.0,
      monto_uyu_pancho: 100.0,
      monto_usd_pancho: 50.0,
      monto_uyu_bruno: 100.0,
      monto_usd_bruno: 50.0
    )
  }

  it "es válido con todos los atributos correctos" do
    expect(subject).to be_valid
  end

  it "no es válido sin fecha" do
    subject.fecha = nil
    expect(subject).to_not be_valid
  end

  it "no es válido sin tipo_cambio" do
    subject.tipo_cambio = nil
    expect(subject).to_not be_valid
  end

  it "no es válido sin sucursal" do
    subject.sucursal = nil
    expect(subject).to_not be_valid
  end

  it "permite montos nulos para todos los montos de los socios" do
    subject.monto_uyu_agustina = nil
    subject.monto_usd_agustina = nil
    subject.monto_uyu_viviana = nil
    subject.monto_usd_viviana = nil
    subject.monto_uyu_gonzalo = nil
    subject.monto_usd_gonzalo = nil
    subject.monto_uyu_pancho = nil
    subject.monto_usd_pancho = nil
    subject.monto_uyu_bruno = nil
    subject.monto_usd_bruno = nil
    expect(subject).to be_valid
  end

  it "valida que tipo_cambio sea numérico mayor que 0" do
    subject.tipo_cambio = -1
    expect(subject).to_not be_valid
  end
end
