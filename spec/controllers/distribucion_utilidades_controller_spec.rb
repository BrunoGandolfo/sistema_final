# spec/controllers/distribucion_utilidades_controller_spec.rb
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
      sucursal: 'Montevideo',
      monto_uyu_agustina: 1000,
      monto_usd_agustina: 50,
      monto_uyu_viviana: 1000,
      monto_usd_viviana: 50,
      monto_uyu_gonzalo: 1000,
      monto_usd_gonzalo: 50,
      monto_uyu_pancho: 1000,
      monto_usd_pancho: 50,
      monto_uyu_bruno: 1000,
      monto_usd_bruno: 50
    }
  end

  let(:invalid_attributes) do
    {
      fecha: nil,              # Falta fecha
      tipo_cambio: -5,         # Tipo de cambio debe ser mayor que 0
      sucursal: '',            # Falta sucursal
      monto_uyu_agustina: 'invalid',
      monto_usd_agustina: 'invalid'
    }
  end

  describe "POST #create" do
    context "when the user is authenticated and authorized" do
      before do
        allow(controller).to receive(:current_user).and_return(authorized_user)
      end

      context "with valid params" do
        it "creates a new DistribucionUtilidad and responds with JSON and status :created" do
          expect {
            post :create, params: { distribucion_utilidad: valid_attributes }, as: :json
          }.to change(DistribucionUtilidad, :count).by(1)
          expect(response).to have_http_status(:created)
          json_response = JSON.parse(response.body)
          expect(json_response["status"]).to eq("success")
          expect(json_response["message"]).to eq("Distribución de utilidades creada correctamente")
        end
      end

      context "with invalid params" do
        it "does not create a new DistribucionUtilidad and responds with errors and status :unprocessable_entity" do
          expect {
            post :create, params: { distribucion_utilidad: invalid_attributes }, as: :json
          }.not_to change(DistribucionUtilidad, :count)
          expect(response).to have_http_status(:unprocessable_entity)
          json_response = JSON.parse(response.body)
          expect(json_response["status"]).to eq("error")
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
        expect(json_response["status"]).to eq("error")
        expect(json_response["message"]).to eq("Acceso no autorizado")
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
        expect(json_response["status"]).to eq("error")
        expect(json_response["message"]).to eq("Usuario no autenticado")
      end
    end
  end
end
