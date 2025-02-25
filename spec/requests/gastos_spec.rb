require 'rails_helper'

RSpec.describe "Gastos API", type: :request do
  let(:user) do
    create(:usuario, 
      email: "test@example.com", 
      password: 'password', 
      password_confirmation: 'password'
    )
  end

  let(:proveedor) { create(:proveedor, nombre: "Proveedor Test") }
  let(:tipo_cambio) { create(:tipo_cambio) }

  # Parámetros válidos para la creación de un Gasto
  let(:valid_attributes) do
    {
      usuario_id: user.id,
      proveedor_id: proveedor.id,
      tipo_cambio_id: tipo_cambio.id,
      monto: 150.0,
      moneda: 'USD',
      fecha: Date.today,
      sucursal: "Montevideo",
      area: "Administración",
      concepto: "Compra de insumos"
    }
  end

  # Parámetros inválidos (fallan validaciones en el modelo)
  let(:invalid_attributes) do
    {
      usuario_id: user.id,
      proveedor_id: proveedor.id,
      tipo_cambio_id: tipo_cambio.id,
      monto: -100,           # Monto inválido (debe ser mayor que 0)
      moneda: 'EUR',         # Moneda inválida (solo se permiten 'USD' o 'UYU')
      fecha: nil,            # Falta fecha
      sucursal: "",          # Falta sucursal
      area: "",              # Falta área
      concepto: ""           # Falta concepto
    }
  end

  describe "POST /gastos" do
    context "cuando el usuario está autenticado" do
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      end

      it "crea un Gasto con parámetros válidos" do
        expect {
          post gastos_path, params: { gasto: valid_attributes }
        }.to change(Gasto, :count).by(1)
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Gasto creado correctamente")
      end

      it "no crea un Gasto con parámetros inválidos" do
        expect {
          post gastos_path, params: { gasto: invalid_attributes }
        }.not_to change(Gasto, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("errors")
      end
    end

    context "cuando el usuario no está autenticado" do
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(nil)
      end

      it "retorna estado no autorizado" do
        post gastos_path, params: { gasto: valid_attributes }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
