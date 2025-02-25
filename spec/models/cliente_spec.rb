require 'rails_helper'

RSpec.describe Cliente, type: :model do
  describe 'validaciones' do
    it { is_expected.to validate_presence_of(:nombre) }
  end

  describe 'asociaciones' do
    # Suponemos que Cliente tiene muchos ingresos
    it { is_expected.to have_many(:ingresos) }
  end

  context 'con atributos válidos' do
    let(:cliente) { create(:cliente) }

    it 'es válido con nombre presente' do
      expect(cliente).to be_valid
    end
  end

  context 'con atributos inválidos' do
    it 'no es válido sin nombre' do
      cliente = Cliente.new(nombre: nil)
      expect(cliente).not_to be_valid
      expect(cliente.errors[:nombre]).to include(I18n.t('activerecord.errors.messages.blank'))
    end
  end
end
