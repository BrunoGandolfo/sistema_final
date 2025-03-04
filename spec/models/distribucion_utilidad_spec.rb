require 'rails_helper'

RSpec.describe DistribucionUtilidad, type: :model do
  describe 'validaciones' do
    it { is_expected.to validate_presence_of(:fecha) }
    it { is_expected.to belong_to(:tipo_cambio) }
    it { is_expected.to belong_to(:usuario).optional(true) }  # Ajustado para reflejar optional:true
    it { is_expected.to validate_presence_of(:sucursal) }  # Cambiado de localidad a sucursal
    it { is_expected.to validate_numericality_of(:monto_uyu_agustina).allow_nil }  # Cambiado de monto_pesos
    it { is_expected.to validate_numericality_of(:monto_usd_agustina).allow_nil }  # Cambiado de monto_dolares
    it { is_expected.to validate_numericality_of(:monto_uyu_viviana).allow_nil }
    it { is_expected.to validate_numericality_of(:monto_usd_viviana).allow_nil }
    it { is_expected.to validate_numericality_of(:monto_uyu_gonzalo).allow_nil }
    it { is_expected.to validate_numericality_of(:monto_usd_gonzalo).allow_nil }
    it { is_expected.to validate_numericality_of(:monto_uyu_pancho).allow_nil }
    it { is_expected.to validate_numericality_of(:monto_usd_pancho).allow_nil }
    it { is_expected.to validate_numericality_of(:monto_uyu_bruno).allow_nil }
    it { is_expected.to validate_numericality_of(:monto_usd_bruno).allow_nil }
  end

  context 'con atributos válidos' do
    let(:usuario) { FactoryBot.create(:usuario) }
    let(:tipo_cambio) { FactoryBot.create(:tipo_cambio) }

    let(:atributos_validos) do
      {
        fecha: Date.today,
        tipo_cambio: tipo_cambio,
        usuario: usuario,
        sucursal: "montevideo",  # Cambiado de localidad a sucursal
        monto_uyu_agustina: 1000.0,  # Cambiado de monto_pesos_agustina
        monto_usd_agustina: 50.0,    # Cambiado de monto_dolares_agustina
        monto_uyu_viviana: 900.0,
        monto_usd_viviana: 45.0,
        monto_uyu_gonzalo: 1100.0,
        monto_usd_gonzalo: 55.0,
        monto_uyu_pancho: 1200.0,
        monto_usd_pancho: 60.0,
        monto_uyu_bruno: 1300.0,
        monto_usd_bruno: 65.0
      }
    end

    it 'es válido con todos los atributos correctos' do
      distribucion = DistribucionUtilidad.new(atributos_validos)
      expect(distribucion).to be_valid
    end

    it 'es válido aun cuando los montos opcionales son nil' do
      distribucion = DistribucionUtilidad.new(atributos_validos.merge(
        monto_uyu_agustina: nil, monto_usd_agustina: nil,
        monto_uyu_viviana: nil, monto_usd_viviana: nil,
        monto_uyu_gonzalo: nil, monto_usd_gonzalo: nil,
        monto_uyu_pancho: nil, monto_usd_pancho: nil,
        monto_uyu_bruno: nil, monto_usd_bruno: nil
      ))
      expect(distribucion).to be_valid
    end
  end

  context 'con atributos inválidos' do
    let(:usuario) { FactoryBot.create(:usuario) }
    let(:tipo_cambio) { FactoryBot.create(:tipo_cambio) }

    let(:atributos_validos) do
      {
        fecha: Date.today,
        tipo_cambio: tipo_cambio,
        usuario: usuario,
        sucursal: "montevideo",  # Cambiado de localidad a sucursal
        monto_uyu_agustina: 1000.0,  # Cambiado de monto_pesos_agustina
        monto_usd_agustina: 50.0,    # Cambiado de monto_dolares_agustina
        monto_uyu_viviana: 900.0,
        monto_usd_viviana: 45.0,
        monto_uyu_gonzalo: 1100.0,
        monto_usd_gonzalo: 55.0,
        monto_uyu_pancho: 1200.0,
        monto_usd_pancho: 60.0,
        monto_uyu_bruno: 1300.0,
        monto_usd_bruno: 65.0
      }
    end

    it 'no es válido sin fecha' do
      distribucion = DistribucionUtilidad.new(atributos_validos.except(:fecha))
      expect(distribucion).not_to be_valid
      expect(distribucion.errors[:fecha]).to include(I18n.t('activerecord.errors.messages.blank'))
    end

    it 'no es válido sin tipo_cambio' do
      distribucion = DistribucionUtilidad.new(atributos_validos.except(:tipo_cambio))
      expect(distribucion).not_to be_valid
      expect(distribucion.errors[:tipo_cambio]).to be_present
    end

    it 'no es válido sin sucursal' do  # Cambiado de localidad a sucursal
      distribucion = DistribucionUtilidad.new(atributos_validos.except(:sucursal))
      expect(distribucion).not_to be_valid
      expect(distribucion.errors[:sucursal]).to include(I18n.t('activerecord.errors.messages.blank'))
    end

    it 'no es válido si monto_uyu_agustina no es numérico' do  # Cambiado de monto_pesos_agustina
      distribucion = DistribucionUtilidad.new(atributos_validos.merge(monto_uyu_agustina: "mil"))
      expect(distribucion).not_to be_valid
      expect(distribucion.errors[:monto_uyu_agustina]).to include(I18n.t('activerecord.errors.messages.not_a_number'))
    end

    it 'no es válido si monto_usd_agustina no es numérico' do  # Cambiado de monto_dolares_agustina
      distribucion = DistribucionUtilidad.new(atributos_validos.merge(monto_usd_agustina: "cincuenta"))
      expect(distribucion).not_to be_valid
      expect(distribucion.errors[:monto_usd_agustina]).to include(I18n.t('activerecord.errors.messages.not_a_number'))
    end

    it 'no es válido si monto_uyu_viviana no es numérico' do  # Cambiado de monto_pesos_viviana
      distribucion = DistribucionUtilidad.new(atributos_validos.merge(monto_uyu_viviana: "novecientos"))
      expect(distribucion).not_to be_valid
      expect(distribucion.errors[:monto_uyu_viviana]).to include(I18n.t('activerecord.errors.messages.not_a_number'))
    end

    it 'no es válido si monto_usd_viviana no es numérico' do  # Cambiado de monto_dolares_viviana
      distribucion = DistribucionUtilidad.new(atributos_validos.merge(monto_usd_viviana: "cuarenta y cinco"))
      expect(distribucion).not_to be_valid
      expect(distribucion.errors[:monto_usd_viviana]).to include(I18n.t('activerecord.errors.messages.not_a_number'))
    end

    it 'no es válido si monto_uyu_gonzalo no es numérico' do  # Cambiado de monto_pesos_gonzalo
      distribucion = DistribucionUtilidad.new(atributos_validos.merge(monto_uyu_gonzalo: "mil ciento"))
      expect(distribucion).not_to be_valid
      expect(distribucion.errors[:monto_uyu_gonzalo]).to include(I18n.t('activerecord.errors.messages.not_a_number'))
    end

    it 'no es válido si monto_usd_gonzalo no es numérico' do  # Cambiado de monto_dolares_gonzalo
      distribucion = DistribucionUtilidad.new(atributos_validos.merge(monto_usd_gonzalo: "cincuenta y cinco"))
      expect(distribucion).not_to be_valid
      expect(distribucion.errors[:monto_usd_gonzalo]).to include(I18n.t('activerecord.errors.messages.not_a_number'))
    end

    it 'no es válido si monto_uyu_pancho no es numérico' do  # Cambiado de monto_pesos_pancho
      distribucion = DistribucionUtilidad.new(atributos_validos.merge(monto_uyu_pancho: "mil doscientos"))
      expect(distribucion).not_to be_valid
      expect(distribucion.errors[:monto_uyu_pancho]).to include(I18n.t('activerecord.errors.messages.not_a_number'))
    end

    it 'no es válido si monto_usd_pancho no es numérico' do  # Cambiado de monto_dolares_pancho
      distribucion = DistribucionUtilidad.new(atributos_validos.merge(monto_usd_pancho: "sesenta"))
      expect(distribucion).not_to be_valid
      expect(distribucion.errors[:monto_usd_pancho]).to include(I18n.t('activerecord.errors.messages.not_a_number'))
    end

    it 'no es válido si monto_uyu_bruno no es numérico' do  # Cambiado de monto_pesos_bruno
      distribucion = DistribucionUtilidad.new(atributos_validos.merge(monto_uyu_bruno: "mil trescientos"))
      expect(distribucion).not_to be_valid
      expect(distribucion.errors[:monto_uyu_bruno]).to include(I18n.t('activerecord.errors.messages.not_a_number'))
    end

    it 'no es válido si monto_usd_bruno no es numérico' do  # Cambiado de monto_dolares_bruno
      distribucion = DistribucionUtilidad.new(atributos_validos.merge(monto_usd_bruno: "sesenta y cinco"))
      expect(distribucion).not_to be_valid
      expect(distribucion.errors[:monto_usd_bruno]).to include(I18n.t('activerecord.errors.messages.not_a_number'))
    end
  end
end
