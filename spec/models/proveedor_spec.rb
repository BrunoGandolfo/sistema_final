require 'rails_helper'

RSpec.describe Proveedor, type: :model do
  describe 'validaciones' do
    it { is_expected.to validate_presence_of(:nombre) }
  end

  describe 'asociaciones' do
    it { is_expected.to have_many(:gastos) }
  end

  context 'con atributos válidos' do
    let(:proveedor) { create(:proveedor) }

    it 'es válido con nombre presente' do
      expect(proveedor).to be_valid
    end
  end

  context 'con atributos inválidos' do
    it 'no es válido sin nombre' do
      proveedor = Proveedor.new(nombre: nil)
      expect(proveedor).not_to be_valid
      expect(proveedor.errors[:nombre]).to include(I18n.t('activerecord.errors.messages.blank'))
    end
  end
end
