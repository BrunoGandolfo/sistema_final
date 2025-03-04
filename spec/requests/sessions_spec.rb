require 'rails_helper'
RSpec.describe "Sessions API", type: :request do
  let(:usuario) { create(:usuario, password: "password123", password_confirmation: "password123") }
  describe "POST /login" do
    context "con credenciales válidas" do
      it "inicia sesión exitosamente" do
        post login_path, params: { email: usuario.email, password: "password123" }
        expect(response).to have_http_status(:success)
        expect(session[:user_id]).to eq(usuario.id)
        json_response = JSON.parse(response.body)
        expect(json_response["status"]).to eq("success")
        expect(json_response["message"]).to eq("Inicio de sesión exitoso")
        expect(json_response["data"]["user"]).to be_present
        expect(json_response["data"]["redirect_to"]).to be_present
      end
    end
    context "con credenciales inválidas" do
      it "falla al iniciar sesión" do
        post login_path, params: { email: usuario.email, password: "contraseña_incorrecta" }
        expect(response).to have_http_status(:unauthorized)
        expect(session[:user_id]).to be_nil
        json_response = JSON.parse(response.body)
        expect(json_response["status"]).to eq("error")
        expect(json_response["message"]).to eq("Email o contraseña inválidos")
      end
    end
  end
  describe "DELETE /session" do
    before do
      post login_path, params: { email: usuario.email, password: "password123" }
    end
    it "cierra sesión exitosamente" do
      delete session_path
      expect(response).to have_http_status(:success)
      expect(session[:user_id]).to be_nil
      json_response = JSON.parse(response.body)
      expect(json_response["status"]).to eq("success")
      expect(json_response["message"]).to eq("Sesión cerrada")
    end
  end
end
