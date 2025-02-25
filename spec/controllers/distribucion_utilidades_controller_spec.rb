require 'rails_helper'

RSpec.describe DistribucionUtilidadesController, type: :controller do
  let(:authorized_user) do
    create(:usuario,
      email: 'socio@example.com',
      password: 'password',
      password_confirmation: 'password',
      rol: 'socio'
    )
  end

  let(:unauthorized_user) do
    create(:usuario,
      email: 'colaborador@example.com',
      password: 'password',
      password_confirmation: 'password',
      rol: 'colaborador'
    )
  end

  let(:valid_attributes) do
    {
      fecha: Date.today,
      tipo_cambio: 35.0,
      sucursal: "Montevideo",
      monto_uyu_agustina: 500,
      monto_usd_agustina: 20,
      monto_uyu_viviana: 500,
      monto_usd_viviana: 20,
      monto_uyu_gonzalo: 500,
      monto_usd_gonzalo: 20,
      monto_uyu_pancho: 500,
      monto_usd_pancho: 20,
      monto_uyu_bruno: 500,
      monto_usd_bruno: 20
    }
  end

  let(:invalid_attributes) do
    {
      fecha: nil,
      tipo_cambio: -10,
      sucursal: "",
      monto_uyu_agustina: "invalid",
      monto_usd_agustina: "invalid",
      monto_uyu_viviana: "invalid",
      monto_usd_viviana: "invalid",
      monto_uyu_gonzalo: "invalid",
      monto_usd_gonzalo: "invalid",
      monto_uyu_pancho: "invalid",
      monto_usd_pancho: "invalid",
      monto_uyu_bruno: "invalid",
      monto_usd_bruno: "invalid"
    }
  end

  describe "POST #create" do
    context "when the user is authenticated and authorized" do
      before do
        allow(controller).to receive(:current_user).and_return(authorized_user)
      end

      context "with valid parameters" do
        it "creates a new DistribucionUtilidad and responds with JSON and status :created" do
          expect {
            post :create, params: { distribucion_utilidad: valid_attributes }, as: :json
          }.to change(DistribucionUtilidad, :count).by(1)
          expect(response).to have_http_status(:created)
          json_response = JSON.parse(response.body)
          expect(json_response["message"]).to eq("Distribución de utilidades creada correctamente")
        end
      end

      context "with invalid parameters" do
        it "does not create a new DistribucionUtilidad and responds with errors and status :unprocessable_entity" do
          expect {
            post :create, params: { distribucion_utilidad: invalid_attributes }, as: :json
          }.not_to change(DistribucionUtilidad, :count)
          expect(response).to have_http_status(:unprocessable_entity)
          json_response = JSON.parse(response.body)
          expect(json_response).to have_key("errors")
        end
      end
    end

    context "when the user is authenticated but not authorized" do
      before do
        allow(controller).to receive(:current_user).and_return(unauthorized_user)
      end

      it "returns status forbidden" do
        post :create, params: { distribucion_utilidad: valid_attributes }, as: :json
        expect(response).to have_http_status(:forbidden)
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Acceso no autorizado")
      end
    end

    context "when the user is not authenticated" do
      before do
        allow(controller).to receive(:current_user).and_return(nil)
      end

      it "returns status unauthorized" do
        post :create, params: { distribucion_utilidad: valid_attributes }, as: :json
        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Usuario no autenticado")
      end
    end
  end
end
