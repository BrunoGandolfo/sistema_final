require 'rails_helper'

RSpec.describe IngresosController, type: :controller do
  let(:usuario)    { create(:usuario) }
  let(:cliente)    { create(:cliente) }
  let(:tipo_cambio){ create(:tipo_cambio) }

  let(:valid_attributes) do
    {
      usuario_id: usuario.id,
      cliente_id: cliente.id,
      tipo_cambio_id: tipo_cambio.id,
      monto: 100.0,
      moneda: 'USD',
      fecha: Date.today,
      sucursal: 'Montevideo',
      area: 'Contable',
      concepto: 'Servicio de consultoría'
    }
  end

  let(:invalid_attributes) do
    {
      usuario_id: nil,
      cliente_id: nil,
      tipo_cambio_id: nil,
      monto: nil,
      moneda: nil,
      fecha: nil,
      sucursal: nil,
      area: nil,
      concepto: nil
    }
  end

  describe "POST #create" do
    context "con parámetros válidos" do
      it "crea un nuevo Ingreso y responde con JSON y status :created" do
        expect {
          post :create, params: { ingreso: valid_attributes }
        }.to change(Ingreso, :count).by(1)
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Ingreso creado correctamente")
      end
    end

    context "con parámetros inválidos" do
      it "no crea un nuevo Ingreso y responde con errores y status :unprocessable_entity" do
        expect {
          post :create, params: { ingreso: invalid_attributes }
        }.not_to change(Ingreso, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("errors")
      end
    end
  end
end
