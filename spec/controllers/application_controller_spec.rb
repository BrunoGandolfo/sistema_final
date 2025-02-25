require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render plain: "OK"
    end
  end

  describe "GET #index" do
    it "devuelve una respuesta exitosa" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
