require 'rails_helper'

RSpec.describe "DistribucionUtilidades API", type: :request do
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

  # Parámetros válidos para la creación de una DistribucionUtilidad
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

  # Parámetros inválidos: violan las validaciones del modelo
  let(:invalid_attributes) do
    {
      fecha: nil,              # Falta fecha
      tipo_cambio: -10,        # Tipo de cambio inválido
      sucursal: "",            # Falta sucursal
      monto_uyu_agustina: "invalido",
      monto_usd_agustina: "invalido",
      monto_uyu_viviana: "invalido",
      monto_usd_viviana: "invalido",
      monto_uyu_gonzalo: "invalido",
      monto_usd_gonzalo: "invalido",
      monto_uyu_pancho: "invalido",
      monto_usd_pancho: "invalido",
      monto_uyu_bruno: "invalido",
      monto_usd_bruno: "invalido"
    }
  end

  describe "POST /distribucion_utilidades" do
    context "cuando el usuario está autenticado y autorizado (socio/admin)" do
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(authorized_user)
      end

      it "crea una DistribucionUtilidad con parámetros válidos" do
        expect {
          post distribucion_utilidades_path, params: { distribucion_utilidad: valid_attributes }
        }.to change(DistribucionUtilidad, :count).by(1)
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Distribución de utilidades creada correctamente")
      end

      it "no crea una DistribucionUtilidad con parámetros inválidos" do
        expect {
          post distribucion_utilidades_path, params: { distribucion_utilidad: invalid_attributes }
        }.not_to change(DistribucionUtilidad, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("errors")
      end
    end

    context "cuando el usuario está autenticado pero no autorizado (colaborador)" do
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(unauthorized_user)
      end

      it "retorna estado prohibido" do
        post distribucion_utilidades_path, params: { distribucion_utilidad: valid_attributes }
        expect(response).to have_http_status(:forbidden)
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Acceso no autorizado")
      end
    end

    context "cuando el usuario no está autenticado" do
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(nil)
      end

      it "retorna estado no autorizado" do
        post distribucion_utilidades_path, params: { distribucion_utilidad: valid_attributes }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
