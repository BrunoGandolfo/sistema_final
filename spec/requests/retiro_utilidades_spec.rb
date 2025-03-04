require 'rails_helper'
RSpec.describe "RetiroUtilidades API", type: :request do
  let(:authorized_user) do
    create(:usuario,
      email: "socio@example.com",
      password: "password",
      password_confirmation: "password",
      rol: "socio"
    )
  end
  let(:unauthorized_user) do
    create(:usuario,
      email: "colaborador@example.com",
      password: "password",
      password_confirmation: "password",
      rol: "colaborador"
    )
  end
  # Parámetros válidos para la creación de un RetiroUtilidad
  let(:valid_attributes) do
    {
      fecha: Date.today,
      tipo_cambio: 35.0,
      sucursal: "Montevideo",
      monto_uyu: 1500,
      monto_usd: 50
    }
  end
  # Parámetros inválidos: violan las validaciones del modelo
  let(:invalid_attributes) do
    {
      fecha: nil,              # Falta fecha
      tipo_cambio: -10,        # Tipo de cambio inválido
      sucursal: "",            # Falta sucursal
      monto_uyu: "invalido",    # Monto inválido
      monto_usd: "invalido"     # Monto inválido
    }
  end
  describe "POST /retiro_utilidades" do
    context "cuando el usuario está autenticado y autorizado (socio/admin)" do
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(authorized_user)
      end
      it "crea un RetiroUtilidad con parámetros válidos" do
        expect {
          post retiro_utilidades_path, params: { retiro_utilidad: valid_attributes }
        }.to change(RetiroUtilidad, :count).by(1)
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response["status"]).to eq("success")
        expect(json_response["message"]).to eq("Retiro de utilidad creado correctamente")
      end
      it "no crea un RetiroUtilidad con parámetros inválidos" do
        expect {
          post retiro_utilidades_path, params: { retiro_utilidad: invalid_attributes }
        }.not_to change(RetiroUtilidad, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["status"]).to eq("error")
        expect(json_response).to have_key("errors")
      end
    end
    context "cuando el usuario está autenticado pero no autorizado (colaborador)" do
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(unauthorized_user)
      end
      it "retorna estado prohibido" do
        post retiro_utilidades_path, params: { retiro_utilidad: valid_attributes }
        expect(response).to have_http_status(:forbidden)
        json_response = JSON.parse(response.body)
        expect(json_response["status"]).to eq("error")
        expect(json_response["message"]).to eq("Acceso no autorizado")
      end
    end
    context "cuando el usuario no está autenticado" do
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(nil)
      end
      it "retorna estado no autorizado" do
        post retiro_utilidades_path, params: { retiro_utilidad: valid_attributes }
        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response["status"]).to eq("error")
        expect(json_response["message"]).to eq("Usuario no autenticado")
      end
    end
  end
end
