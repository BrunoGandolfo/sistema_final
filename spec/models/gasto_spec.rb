require 'rails_helper'

RSpec.describe Gasto, type: :model do
  describe 'asociaciones' do
    it { is_expected.to belong_to(:usuario) }
    it { is_expected.to belong_to(:proveedor) }
    it { is_expected.to belong_to(:tipo_cambio) }
  end

  describe 'validaciones' do
    it { is_expected.to validate_presence_of(:monto) }
    it { is_expected.to validate_numericality_of(:monto).is_greater_than(0) }
    it { is_expected.to validate_presence_of(:moneda) }
    it { is_expected.to validate_inclusion_of(:moneda).in_array(['USD', 'UYU']) }
    it { is_expected.to validate_presence_of(:fecha) }
    it { is_expected.to validate_presence_of(:sucursal) }
    it { is_expected.to validate_presence_of(:area) }
    it { is_expected.to validate_presence_of(:concepto) }
  end

  context 'con atributos válidos' do
    let(:usuario)     { create(:usuario) }
    let(:proveedor)   { create(:proveedor) }
    let(:tipo_cambio) { create(:tipo_cambio) }

    let(:atributos_validos) do
      {
        monto: 200.0,
        moneda: 'UYU',
        fecha: Date.today,
        sucursal: 'Montevideo',
        area: 'Legal',
        concepto: 'Pago de servicios',
        usuario: usuario,
        proveedor: proveedor,
        tipo_cambio: tipo_cambio
      }
    end

    it 'es válido con todos los atributos correctos' do
      gasto = Gasto.new(atributos_validos)
      expect(gasto).to be_valid
    end
  end

  context 'con atributos inválidos' do
    let(:usuario)     { create(:usuario) }
    let(:proveedor)   { create(:proveedor) }
    let(:tipo_cambio) { create(:tipo_cambio) }

    let(:atributos_validos) do
      {
        monto: 200.0,
        moneda: 'UYU',
        fecha: Date.today,
        sucursal: 'Montevideo',
        area: 'Legal',
        concepto: 'Pago de servicios',
        usuario: usuario,
        proveedor: proveedor,
        tipo_cambio: tipo_cambio
      }
    end

    it 'no es válido sin monto' do
      gasto = Gasto.new(atributos_validos.except(:monto))
      expect(gasto).not_to be_valid
      expect(gasto.errors[:monto]).to include(I18n.t('activerecord.errors.messages.blank'))
    end

    it 'no es válido con monto no numérico' do
      gasto = Gasto.new(atributos_validos.merge(monto: 'doscientos'))
      expect(gasto).not_to be_valid
      expect(gasto.errors[:monto]).to include(I18n.t('activerecord.errors.messages.not_a_number'))
    end

    it 'no es válido con monto menor o igual a 0' do
      gasto = Gasto.new(atributos_validos.merge(monto: 0))
      expect(gasto).not_to be_valid

      gasto = Gasto.new(atributos_validos.merge(monto: -20))
      expect(gasto).not_to be_valid
    end

    it 'no es válido sin moneda' do
      gasto = Gasto.new(atributos_validos.except(:moneda))
      expect(gasto).not_to be_valid
      expect(gasto.errors[:moneda]).to include(I18n.t('activerecord.errors.messages.blank'))
    end

    it 'no es válido con moneda inválida' do
      gasto = Gasto.new(atributos_validos.merge(moneda: 'EUR'))
      expect(gasto).not_to be_valid
      expect(gasto.errors[:moneda]).to include(I18n.t('activerecord.errors.messages.inclusion'))
    end

    it 'no es válido sin fecha' do
      gasto = Gasto.new(atributos_validos.except(:fecha))
      expect(gasto).not_to be_valid
      expect(gasto.errors[:fecha]).to include(I18n.t('activerecord.errors.messages.blank'))
    end

    it 'no es válido sin sucursal' do
      gasto = Gasto.new(atributos_validos.except(:sucursal))
      expect(gasto).not_to be_valid
      expect(gasto.errors[:sucursal]).to include(I18n.t('activerecord.errors.messages.blank'))
    end

    it 'no es válido sin área' do
      gasto = Gasto.new(atributos_validos.except(:area))
      expect(gasto).not_to be_valid
      expect(gasto.errors[:area]).to include(I18n.t('activerecord.errors.messages.blank'))
    end

    it 'no es válido sin concepto' do
      gasto = Gasto.new(atributos_validos.except(:concepto))
      expect(gasto).not_to be_valid
      expect(gasto.errors[:concepto]).to include(I18n.t('activerecord.errors.messages.blank'))
    end
  end
end
