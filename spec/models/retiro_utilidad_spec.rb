require 'rails_helper'

RSpec.describe RetiroUtilidad, type: :model do
  subject {
    RetiroUtilidad.new(
      fecha: Time.current,
      tipo_cambio: 1.23,
      sucursal: "Montevideo",
      monto_uyu: 100.0,
      monto_usd: 50.0
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

  it "permite montos nulos" do
    subject.monto_uyu = nil
    subject.monto_usd = nil
    expect(subject).to be_valid
  end

  it "valida que tipo_cambio sea numérico mayor que 0" do
    subject.tipo_cambio = -1
    expect(subject).to_not be_valid
  end
end
