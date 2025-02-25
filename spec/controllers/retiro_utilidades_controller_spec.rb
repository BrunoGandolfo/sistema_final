require 'rails_helper'

RSpec.describe RetiroUtilidadesController, type: :controller do
  let(:valid_attributes) do
    {
      fecha: Date.today,
      tipo_cambio: 1.2,
      sucursal: 'Montevideo',
      monto_uyu: 1000.0,
      monto_usd: 50.0
    }
  end

  let(:invalid_attributes) do
    {
      fecha: nil,
      tipo_cambio: nil,
      sucursal: nil,
      monto_uyu: nil,
      monto_usd: nil
    }
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new RetiroUtilidad and responds with JSON and status :created" do
        expect {
          post :create, params: { retiro_utilidad: valid_attributes }
        }.to change(RetiroUtilidad, :count).by(1)
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Retiro de utilidad creado correctamente")
      end
    end

    context "with invalid parameters" do
      it "does not create a new RetiroUtilidad and responds with errors and status :unprocessable_entity" do
        expect {
          post :create, params: { retiro_utilidad: invalid_attributes }
        }.not_to change(RetiroUtilidad, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("errors")
      end
    end
  end
end
