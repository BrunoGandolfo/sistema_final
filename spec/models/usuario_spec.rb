require 'rails_helper'

RSpec.describe Usuario, type: :model do
  describe "#has_full_access?" do
    subject { usuario.has_full_access? }

    context "when user is admin" do
      let(:usuario) { Usuario.new(rol: "admin") }
      it { is_expected.to be_truthy }
    end

    context "when user is socio" do
      let(:usuario) { Usuario.new(rol: "socio") }
      it { is_expected.to be_truthy }
    end

    context "when user is colaborador" do
      let(:usuario) { Usuario.new(rol: "colaborador") }
      it { is_expected.to be_falsey }
    end
  end

  describe "assign_role callback" do
    context "when email is in socios_emails" do
      let(:usuario) { Usuario.new(email: "socio1@example.com", nombre: "Test", password: "password", password_confirmation: "password") }
      it "assigns role as socio" do
        usuario.save!
        expect(usuario.rol).to eq("socio")
      end
    end

    context "when email is not in socios_emails" do
      let(:usuario) { Usuario.new(email: "user@example.com", nombre: "Test", password: "password", password_confirmation: "password") }
      it "assigns role as colaborador" do
        usuario.save!
        expect(usuario.rol).to eq("colaborador")
      end
    end
  end
end
