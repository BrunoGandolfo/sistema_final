require 'rails_helper'

RSpec.describe MetricsController, type: :controller do
  let(:restricted_user) do
    create(:usuario,
      email: 'colaborador@example.com',
      password: 'password',
      password_confirmation: 'password',
      rol: 'colaborador'
    )
  end

  describe "GET #index" do
    context "cuando el usuario no tiene acceso completo" do
      before do
        allow(controller).to receive(:current_user).and_return(restricted_user)
      end

      it "returns forbidden status" do
        get :index, as: :json
        expect(response).to have_http_status(:forbidden)
      end

      it "returns an error message" do
        get :index, as: :json
        json = JSON.parse(response.body)
        expect(json["error"]).to eq("Acceso no autorizado")
      end
    end
  end
end
