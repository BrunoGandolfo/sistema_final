require 'rails_helper'

RSpec.describe Ingreso, type: :model do
  describe 'asociaciones' do
    it { is_expected.to belong_to(:usuario) }
    it { is_expected.to belong_to(:cliente) }
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

  describe 'métodos de clase' do
    describe '.crear_con_usuario' do
      let(:usuario) { create(:usuario) }
      let(:cliente) { create(:cliente) }
      let(:tipo_cambio) { create(:tipo_cambio) }
      
      let(:parametros_validos) do
        {
          monto: 100.0,
          moneda: 'USD',
          fecha: Date.today,
          sucursal: 'Montevideo',
          area: 'Contable',
          concepto: 'Servicio de consultoría',
          cliente_id: cliente.id,
          tipo_cambio_id: tipo_cambio.id
        }
      end
      
      it 'crea un ingreso y le asigna el usuario' do
        ingreso = Ingreso.crear_con_usuario(parametros_validos, usuario)
        
        expect(ingreso).to be_persisted
        expect(ingreso.usuario).to eq(usuario)
        expect(ingreso.monto).to eq(100.0)
      end
      
      it 'devuelve el ingreso sin persistir si hay errores' do
        parametros_invalidos = parametros_validos.except(:monto)
        ingreso = Ingreso.crear_con_usuario(parametros_invalidos, usuario)
        
        expect(ingreso).not_to be_persisted
        expect(ingreso.errors[:monto]).to be_present
      end
    end
  end

  context 'con atributos válidos' do
    let(:usuario) { create(:usuario) }
    let(:cliente) { create(:cliente) }
    let(:tipo_cambio) { create(:tipo_cambio) }

    let(:atributos_validos) do
      {
        monto: 100.0,
        moneda: 'USD',
        fecha: Date.today,
        sucursal: 'Montevideo',
        area: 'Contable',
        concepto: 'Servicio de consultoría',
        usuario: usuario,
        cliente: cliente,
        tipo_cambio: tipo_cambio
      }
    end

    it 'es válido con todos los atributos correctos' do
      ingreso = Ingreso.new(atributos_validos)
      expect(ingreso).to be_valid
    end
  end

  context 'con atributos inválidos' do
    let(:usuario) { create(:usuario) }
    let(:cliente) { create(:cliente) }
    let(:tipo_cambio) { create(:tipo_cambio) }

    let(:atributos_validos) do
      {
        monto: 100.0,
        moneda: 'USD',
        fecha: Date.today,
        sucursal: 'Montevideo',
        area: 'Contable',
        concepto: 'Servicio de consultoría',
        usuario: usuario,
        cliente: cliente,
        tipo_cambio: tipo_cambio
      }
    end

    it 'no es válido sin monto' do
      ingreso = Ingreso.new(atributos_validos.except(:monto))
      expect(ingreso).not_to be_valid
      expect(ingreso.errors[:monto]).to include(I18n.t('activerecord.errors.messages.blank'))
    end

    it 'no es válido con monto no numérico' do
      ingreso = Ingreso.new(atributos_validos.merge(monto: 'cien'))
      expect(ingreso).not_to be_valid
      expect(ingreso.errors[:monto]).to include(I18n.t('activerecord.errors.messages.not_a_number'))
    end

    it 'no es válido con monto menor o igual a 0' do
      ingreso = Ingreso.new(atributos_validos.merge(monto: 0))
      expect(ingreso).not_to be_valid

      ingreso = Ingreso.new(atributos_validos.merge(monto: -50))
      expect(ingreso).not_to be_valid
    end

    it 'no es válido sin moneda' do
      ingreso = Ingreso.new(atributos_validos.except(:moneda))
      expect(ingreso).not_to be_valid
      expect(ingreso.errors[:moneda]).to include(I18n.t('activerecord.errors.messages.blank'))
    end

    it 'no es válido con moneda inválida' do
      ingreso = Ingreso.new(atributos_validos.merge(moneda: 'EUR'))
      expect(ingreso).not_to be_valid
      expect(ingreso.errors[:moneda]).to include(I18n.t('activerecord.errors.messages.inclusion'))
    end

    it 'no es válido sin fecha' do
      ingreso = Ingreso.new(atributos_validos.except(:fecha))
      expect(ingreso).not_to be_valid
      expect(ingreso.errors[:fecha]).to include(I18n.t('activerecord.errors.messages.blank'))
    end

    it 'no es válido sin sucursal' do
      ingreso = Ingreso.new(atributos_validos.except(:sucursal))
      expect(ingreso).not_to be_valid
      expect(ingreso.errors[:sucursal]).to include(I18n.t('activerecord.errors.messages.blank'))
    end

    it 'no es válido sin área' do
      ingreso = Ingreso.new(atributos_validos.except(:area))
      expect(ingreso).not_to be_valid
      expect(ingreso.errors[:area]).to include(I18n.t('activerecord.errors.messages.blank'))
    end

    it 'no es válido sin concepto' do
      ingreso = Ingreso.new(atributos_validos.except(:concepto))
      expect(ingreso).not_to be_valid
      expect(ingreso.errors[:concepto]).to include(I18n.t('activerecord.errors.messages.blank'))
    end
  end
end
