require 'rails_helper'

RSpec.describe "Sessions API", type: :request do
  let(:user) do
    create(:usuario, 
      email: "test@example.com", 
      password: "password", 
      password_confirmation: "password"
    )
  end

  describe "POST /login" do
    context "con credenciales válidas" do
      it "inicia sesión exitosamente" do
        post login_path, params: { email: user.email, password: "password" }
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Inicio de sesión exitoso")
        expect(json_response["user"]).to be_present
      end
    end

    context "con credenciales inválidas" do
      it "falla al iniciar sesión" do
        post login_path, params: { email: user.email, password: "wrongpassword" }
        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Email o contraseña inválidos")
      end
    end
  end

  describe "DELETE /session" do
    before do
      # Simulamos que el usuario está autenticado
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    it "cierra la sesión exitosamente" do
      delete session_path
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["message"]).to eq("Sesión cerrada")
    end
  end
end
