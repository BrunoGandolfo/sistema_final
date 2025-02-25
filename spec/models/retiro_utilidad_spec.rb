require 'rails_helper'

RSpec.describe RetiroUtilidad, type: :model do
  describe 'validaciones' do
    it { is_expected.to validate_presence_of(:fecha) }
    it { is_expected.to validate_presence_of(:tipo_cambio) }
    it { is_expected.to validate_numericality_of(:tipo_cambio).is_greater_than(0) }
    it { is_expected.to validate_presence_of(:sucursal) }
    it { is_expected.to validate_numericality_of(:monto_uyu).allow_nil }
    it { is_expected.to validate_numericality_of(:monto_usd).allow_nil }
  end

  context 'con atributos válidos' do
    let(:atributos_validos) do
      {
        fecha: Date.today,
        tipo_cambio: 1.2,
        sucursal: "Montevideo",
        monto_uyu: 1000.0,
        monto_usd: 50.0
      }
    end

    it 'es válido con todos los atributos correctos' do
      retiro = RetiroUtilidad.new(atributos_validos)
      expect(retiro).to be_valid
    end

    it 'es válido aun cuando los montos son nil' do
      retiro = RetiroUtilidad.new(atributos_validos.merge(monto_uyu: nil, monto_usd: nil))
      expect(retiro).to be_valid
    end
  end

  context 'con atributos inválidos' do
    let(:atributos_validos) do
      {
        fecha: Date.today,
        tipo_cambio: 1.2,
        sucursal: "Montevideo",
        monto_uyu: 1000.0,
        monto_usd: 50.0
      }
    end

    it 'no es válido sin fecha' do
      retiro = RetiroUtilidad.new(atributos_validos.except(:fecha))
      expect(retiro).not_to be_valid
      expect(retiro.errors[:fecha]).to include(I18n.t('activerecord.errors.messages.blank'))
    end

    it 'no es válido sin tipo_cambio' do
      retiro = RetiroUtilidad.new(atributos_validos.except(:tipo_cambio))
      expect(retiro).not_to be_valid
      expect(retiro.errors[:tipo_cambio]).to include(I18n.t('activerecord.errors.messages.blank'))
    end

    it 'no es válido con tipo_cambio menor o igual a 0' do
      retiro = RetiroUtilidad.new(atributos_validos.merge(tipo_cambio: 0))
      expect(retiro).not_to be_valid

      retiro = RetiroUtilidad.new(atributos_validos.merge(tipo_cambio: -1))
      expect(retiro).not_to be_valid
    end

    it 'no es válido sin sucursal' do
      retiro = RetiroUtilidad.new(atributos_validos.except(:sucursal))
      expect(retiro).not_to be_valid
      expect(retiro.errors[:sucursal]).to include(I18n.t('activerecord.errors.messages.blank'))
    end

    it 'no es válido si monto_uyu no es numérico' do
      retiro = RetiroUtilidad.new(atributos_validos.merge(monto_uyu: "mil"))
      expect(retiro).not_to be_valid
      expect(retiro.errors[:monto_uyu]).to include(I18n.t('activerecord.errors.messages.not_a_number'))
    end

    it 'no es válido si monto_usd no es numérico' do
      retiro = RetiroUtilidad.new(atributos_validos.merge(monto_usd: "cincuenta"))
      expect(retiro).not_to be_valid
      expect(retiro.errors[:monto_usd]).to include(I18n.t('activerecord.errors.messages.not_a_number'))
    end
  end
end
