require 'rails_helper'

RSpec.describe IngresosController, type: :controller do
  let(:user) do
    create(:usuario,
      email: 'test@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
  end

  let(:cliente) { create(:cliente, nombre: 'Cliente Test') }
  let(:tipo_cambio) { create(:tipo_cambio) }

  let(:valid_attributes) do
    {
      usuario_id: user.id,
      cliente_id: cliente.id,
      tipo_cambio_id: tipo_cambio.id,
      monto: 150.0,
      moneda: 'USD',
      fecha: Date.today,
      sucursal: 'Montevideo',
      area: 'Consultoría',
      concepto: 'Servicio de consultoría'
    }
  end

  let(:invalid_attributes) do
    {
      usuario_id: user.id,
      cliente_id: cliente.id,
      tipo_cambio_id: tipo_cambio.id,
      monto: -100,           # Monto inválido (debe ser mayor que 0)
      moneda: 'EUR',         # Moneda inválida (solo se permiten 'USD' o 'UYU')
      fecha: nil,            # Falta fecha
      sucursal: '',          # Falta sucursal
      area: '',              # Falta área
      concepto: ''           # Falta concepto
    }
  end

  describe "POST #create" do
    context "cuando el usuario está autenticado" do
      before do
        allow(controller).to receive(:current_user).and_return(user)
      end

      context "con parámetros válidos" do
        it "crea un nuevo Ingreso y responde con JSON y status :created" do
          expect {
            post :create, params: { ingreso: valid_attributes }, as: :json
          }.to change(Ingreso, :count).by(1)
          expect(response).to have_http_status(:created)
          json_response = JSON.parse(response.body)
          expect(json_response["message"]).to eq("Ingreso creado correctamente")
        end
      end

      context "con parámetros inválidos" do
        it "no crea un nuevo Ingreso y responde con errores y status :unprocessable_entity" do
          expect {
            post :create, params: { ingreso: invalid_attributes }, as: :json
          }.not_to change(Ingreso, :count)
          expect(response).to have_http_status(:unprocessable_entity)
          json_response = JSON.parse(response.body)
          expect(json_response).to have_key("errors")
        end
      end
    end

    context "cuando el usuario no está autenticado" do
      before do
        allow(controller).to receive(:current_user).and_return(nil)
      end

      it "retorna status no autorizado" do
        post :create, params: { ingreso: valid_attributes }, as: :json
        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Usuario no autenticado")
      end
    end
  end
end
