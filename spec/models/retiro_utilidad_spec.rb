require 'rails_helper'
RSpec.describe RetiroUtilidad, type: :model do
  describe 'validaciones' do
    it { is_expected.to validate_presence_of(:fecha) }
    it { is_expected.to belong_to(:tipo_cambio) }
    it { is_expected.to belong_to(:usuario).optional(true) }  # Ajustado para reflejar optional:true
    it { is_expected.to validate_presence_of(:sucursal) }  # Cambiado de localidad a sucursal
    it { is_expected.to validate_numericality_of(:monto_uyu).allow_nil }  # Cambiado de monto_pesos
    it { is_expected.to validate_numericality_of(:monto_usd).allow_nil }  # Cambiado de monto_dolares
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
        monto_uyu: 1000.0,       # Cambiado de monto_pesos
        monto_usd: 50.0          # Cambiado de monto_dolares
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
    let(:usuario) { FactoryBot.create(:usuario) }
    let(:tipo_cambio) { FactoryBot.create(:tipo_cambio) }
    
    let(:atributos_validos) do
      {
        fecha: Date.today,
        tipo_cambio: tipo_cambio,
        usuario: usuario,
        sucursal: "montevideo",  # Cambiado de localidad a sucursal
        monto_uyu: 1000.0,       # Cambiado de monto_pesos
        monto_usd: 50.0          # Cambiado de monto_dolares
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
      expect(retiro.errors[:tipo_cambio]).to be_present
    end
    
    it 'no es válido sin sucursal' do  # Cambiado de localidad a sucursal
      retiro = RetiroUtilidad.new(atributos_validos.except(:sucursal))
      expect(retiro).not_to be_valid
      expect(retiro.errors[:sucursal]).to include(I18n.t('activerecord.errors.messages.blank'))
    end
    
    it 'no es válido si monto_uyu no es numérico' do  # Cambiado de monto_pesos
      retiro = RetiroUtilidad.new(atributos_validos.merge(monto_uyu: "mil"))
      expect(retiro).not_to be_valid
      expect(retiro.errors[:monto_uyu]).to include(I18n.t('activerecord.errors.messages.not_a_number'))
    end
    
    it 'no es válido si monto_usd no es numérico' do  # Cambiado de monto_dolares
      retiro = RetiroUtilidad.new(atributos_validos.merge(monto_usd: "cincuenta"))
      expect(retiro).not_to be_valid
      expect(retiro.errors[:monto_usd]).to include(I18n.t('activerecord.errors.messages.not_a_number'))
    end
  end
end
