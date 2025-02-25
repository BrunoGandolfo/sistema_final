require 'rails_helper'

RSpec.describe DistribucionUtilidadesController, type: :controller do
  let(:valid_attributes) do
    {
      fecha: Date.today,
      tipo_cambio: 1.5,
      sucursal: 'Montevideo',
      monto_uyu_agustina: 1000.0,
      monto_usd_agustina: 50.0,
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

  let(:invalid_attributes) do
    {
      fecha: nil,
      tipo_cambio: nil,
      sucursal: nil,
      monto_uyu_agustina: nil,
      monto_usd_agustina: nil,
      monto_uyu_viviana: nil,
      monto_usd_viviana: nil,
      monto_uyu_gonzalo: nil,
      monto_usd_gonzalo: nil,
      monto_uyu_pancho: nil,
      monto_usd_pancho: nil,
      monto_uyu_bruno: nil,
      monto_usd_bruno: nil
    }
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new DistribucionUtilidad and responds with JSON and status :created" do
        expect {
          post :create, params: { distribucion_utilidad: valid_attributes }
        }.to change(DistribucionUtilidad, :count).by(1)
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Distribución de utilidades creada correctamente")
      end
    end

    context "with invalid parameters" do
      it "does not create a new DistribucionUtilidad and responds with errors and status :unprocessable_entity" do
        expect {
          post :create, params: { distribucion_utilidad: invalid_attributes }
        }.not_to change(DistribucionUtilidad, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("errors")
      end
    end
  end
end
