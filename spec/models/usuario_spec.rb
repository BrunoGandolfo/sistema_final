require 'rails_helper'

RSpec.describe Usuario, type: :model do
  subject do
    described_class.new(
      nombre: "Usuario de Prueba",
      email: "usuario@example.com",
      password: "password",
      password_confirmation: "password",
      rol: "colaborador" # Cambia a 'admin' o 'socio' para probar otros roles
    )
  end

  describe "validaciones" do
    it "es válido con atributos válidos" do
      expect(subject).to be_valid
    end

    it "no es válido sin nombre" do
      subject.nombre = nil
      subject.valid?
      expect(subject.errors[:nombre]).to include("no puede estar en blanco")
    end

    it "no es válido sin email" do
      subject.email = nil
      subject.valid?
      expect(subject.errors[:email]).to include("no puede estar en blanco")
    end

    it "no es válido con un email en formato incorrecto" do
      subject.email = "usuario_incorrecto"
      subject.valid?
      expect(subject.errors[:email]).not_to be_empty
    end

    it "no es válido sin password cuando se crea" do
      subject.password = subject.password_confirmation = nil
      subject.valid?
      expect(subject.errors[:password]).not_to be_empty
    end

    it "no es válido si el password y su confirmación no coinciden" do
      subject.password_confirmation = "otra_contraseña"
      subject.valid?
      expect(subject.errors[:password_confirmation]).not_to be_empty
    end

    it "solo acepta los roles permitidos" do
      # Se espera que al asignar un rol no permitido se lance un ArgumentError
      expect { subject.rol = "empleado" }.to raise_error(ArgumentError)
    end
  end
end
