# spec/controllers/retiro_utilidades_controller_spec.rb
require 'rails_helper'

RSpec.describe RetiroUtilidadesController, type: :controller do
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
      monto_uyu: 1000,
      monto_usd: 50
    }
  end

  let(:invalid_attributes) do
    {
      fecha: nil,              # Falta fecha
      tipo_cambio: -5,         # Tipo de cambio debe ser mayor que 0
      sucursal: '',            # Falta sucursal
      monto_uyu: 'invalid',    # Debe ser numérico
      monto_usd: 'invalid'     # Debe ser numérico
    }
  end

  describe "POST #create" do
    context "cuando el usuario está autenticado y autorizado" do
      before do
        allow(controller).to receive(:current_user).and_return(authorized_user)
      end

      context "con parámetros válidos" do
        it "crea un nuevo RetiroUtilidad y responde con JSON y status :created" do
          expect {
            post :create, params: { retiro_utilidad: valid_attributes }, as: :json
          }.to change(RetiroUtilidad, :count).by(1)
          expect(response).to have_http_status(:created)
          json_response = JSON.parse(response.body)
          expect(json_response["status"]).to eq("success")
          expect(json_response["message"]).to eq("Retiro de utilidad creado correctamente")
        end
      end

      context "con parámetros inválidos" do
        it "no crea un nuevo RetiroUtilidad y responde con errores y status :unprocessable_entity" do
          expect {
            post :create, params: { retiro_utilidad: invalid_attributes }, as: :json
          }.not_to change(RetiroUtilidad, :count)
          expect(response).to have_http_status(:unprocessable_entity)
          json_response = JSON.parse(response.body)
          expect(json_response["status"]).to eq("error")
          expect(json_response).to have_key("errors")
        end
      end
    end

    context "cuando el usuario está autenticado pero no autorizado" do
      before do
        allow(controller).to receive(:current_user).and_return(unauthorized_user)
      end

      it "retorna status forbidden con error de autorización" do
        post :create, params: { retiro_utilidad: valid_attributes }, as: :json
        expect(response).to have_http_status(:forbidden)
        json_response = JSON.parse(response.body)
        expect(json_response["status"]).to eq("error")
        expect(json_response["message"]).to eq("Acceso no autorizado")
      end
    end

    context "cuando el usuario no está autenticado" do
      before do
        allow(controller).to receive(:current_user).and_return(nil)
      end

      it "retorna status unauthorized" do
        post :create, params: { retiro_utilidad: valid_attributes }, as: :json
        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response["status"]).to eq("error")
        expect(json_response["message"]).to eq("Usuario no autenticado")
      end
    end
  end
end
