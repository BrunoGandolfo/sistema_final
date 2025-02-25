require 'rails_helper'

RSpec.describe MetricsController, type: :controller do
  describe "GET #index" do
    context "when user does not have full access" do
      let(:usuario) { Usuario.create!(nombre: "User", email: "user@example.com", password: "password", password_confirmation: "password", rol: "colaborador") }
      before do
        session[:user_id] = usuario.id
        get :index
      end

      it "returns forbidden status" do
        expect(response).to have_http_status(:forbidden)
      end

      it "returns an error message" do
        json = JSON.parse(response.body)
        expect(json["error"]).to eq("Acceso no autorizado")
      end
    end

    context "when user has full access" do
      let(:usuario) { Usuario.create!(nombre: "Socio", email: "socio1@example.com", password: "password", password_confirmation: "password", rol: "socio") }
      before do
        session[:user_id] = usuario.id
        get :index
      end

      it "returns ok status" do
        expect(response).to have_http_status(:ok)
      end

      it "returns the metrics JSON" do
        json = JSON.parse(response.body)
        expect(json["metrics"]).to be_an(Array)
      end
    end
  end
end
