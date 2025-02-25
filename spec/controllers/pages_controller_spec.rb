require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe "GET #home" do
    context "cuando no hay usuario autenticado" do
      it "renderiza la vista home y prepara un nuevo usuario" do
        get :home
        expect(response).to have_http_status(:ok)
        expect(assigns(:user)).to be_a_new(Usuario)
      end
    end

    context "cuando hay un usuario autenticado" do
      let(:usuario) { create(:usuario) }
      
      before do
        # Simular que el usuario está autenticado
        allow(controller).to receive(:current_user).and_return(usuario)
      end

      it "redirige al dashboard" do
        get :home
        expect(response).to redirect_to(dashboard_path)
      end
    end
  end
end
