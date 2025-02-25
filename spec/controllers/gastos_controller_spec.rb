require 'rails_helper'

RSpec.describe GastosController, type: :controller do
  let(:usuario)     { create(:usuario) }
  let(:proveedor)   { create(:proveedor) }
  let(:tipo_cambio) { create(:tipo_cambio) }

  let(:valid_attributes) do
    {
      usuario_id: usuario.id,
      proveedor_id: proveedor.id,
      tipo_cambio_id: tipo_cambio.id,
      monto: 150.0,
      moneda: 'UYU',
      fecha: Date.today,
      sucursal: 'Montevideo',
      area: 'Legal',
      concepto: 'Pago de servicios'
    }
  end

  let(:invalid_attributes) do
    {
      usuario_id: nil,
      proveedor_id: nil,
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
      it "crea un nuevo Gasto y responde con JSON y status :created" do
        expect {
          post :create, params: { gasto: valid_attributes }
        }.to change(Gasto, :count).by(1)
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Gasto creado correctamente")
      end
    end

    context "con parámetros inválidos" do
      it "no crea un nuevo Gasto y responde con errores y status :unprocessable_entity" do
        expect {
          post :create, params: { gasto: invalid_attributes }
        }.not_to change(Gasto, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("errors")
      end
    end
  end
end
