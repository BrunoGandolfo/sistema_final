require 'rails_helper'
RSpec.describe MetricsController, type: :controller do
  describe "GET #index" do
    context "cuando el usuario tiene acceso completo" do
      let(:socio) { create(:usuario, rol: "socio") }
      before do
        allow(controller).to receive(:current_user).and_return(socio)
      end
      it "returns all metrics" do
        get :index, as: :json
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json).to have_key("metrics")
      end
    end
    context "cuando el usuario no tiene acceso completo" do
      let(:colaborador) { create(:usuario, rol: "colaborador") }
      before do
        allow(controller).to receive(:current_user).and_return(colaborador)
        allow(colaborador).to receive(:has_full_access?).and_return(false)
      end
      it "returns an error message" do
        get :index, as: :json
        expect(response).to have_http_status(:forbidden)
        json = JSON.parse(response.body)
        expect(json["status"]).to eq("error")
        expect(json["message"]).to eq("Acceso no autorizado")
      end
    end
    context "cuando no hay usuario autenticado" do
      before do
        allow(controller).to receive(:current_user).and_return(nil)
      end
      it "returns unauthorized status" do
        get :index, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
