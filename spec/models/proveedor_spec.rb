require 'rails_helper'

RSpec.describe Proveedor, type: :model do
  subject { Proveedor.new(nombre: "Proveedor Test") }

  it "es válido con nombre presente" do
    expect(subject).to be_valid
  end

  it "no es válido sin nombre" do
    subject.nombre = nil
    expect(subject).to_not be_valid
  end
end
