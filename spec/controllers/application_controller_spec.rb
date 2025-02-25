require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  # Definimos un controlador anónimo para probar el comportamiento en ApplicationController
  controller do
    def index
      render json: { message: 'ok' }
    end
  end

  before do
    # Simulamos que hay un usuario autenticado para evitar el filtro de autenticación
    allow(controller).to receive(:current_user).and_return(create(:usuario))
  end

  describe "GET #index" do
    it "devuelve una respuesta exitosa" do
      get :index, as: :json
      expect(response).to have_http_status(:success)
    end
  end
end
