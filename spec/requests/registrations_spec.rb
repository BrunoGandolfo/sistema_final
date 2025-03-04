require 'rails_helper'
RSpec.describe "Registrations API", type: :request do
  # Parámetros válidos para el registro de un usuario
  let(:valid_attributes) do
    {
      nombre: "Usuario Test",
      email: "usuario@test.com",
      password: "password",
      password_confirmation: "password"
    }
  end
  # Parámetros inválidos para el registro (faltan datos obligatorios o datos no válidos)
  let(:invalid_attributes) do
    {
      nombre: "",
      email: "correo_invalido",
      password: "123",
      password_confirmation: "456"
    }
  end
  describe "POST /signup" do
    context "con datos válidos" do
      it "registra un nuevo usuario y establece la sesión" do
        expect {
          post signup_path, params: valid_attributes
        }.to change(Usuario, :count).by(1)
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Usuario registrado exitosamente")
        expect(json_response["user"]).to be_present
      end
    end
    context "con datos inválidos" do
      it "no registra el usuario y retorna errores" do
        expect {
          post signup_path, params: invalid_attributes
        }.not_to change(Usuario, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("errors")
      end
    end
    context "con email duplicado" do
      before do
        create(:usuario, valid_attributes)
      end
      it "no registra el usuario y retorna errores de email duplicado" do
        expect {
          post signup_path, params: valid_attributes
        }.not_to change(Usuario, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        # Modificado para aceptar cualquiera de los dos términos
        expect(json_response["errors"].join).to match(/Email|Correo electrónico/i)
      end
    end
  end
end
