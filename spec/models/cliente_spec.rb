require 'rails_helper'

RSpec.describe Cliente, type: :model do
  subject { Cliente.new(nombre: "Cliente Test") }

  it "es válido con nombre presente" do
    expect(subject).to be_valid
  end

  it "no es válido sin nombre" do
    subject.nombre = nil
    expect(subject).to_not be_valid
  end
end
