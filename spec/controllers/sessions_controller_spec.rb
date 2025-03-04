# spec/controllers/sessions_controller_spec.rb
require 'rails_helper'
RSpec.describe SessionsController, type: :controller do
  let(:usuario) { create(:usuario, email: 'test@example.com', password: 'password123') }

  describe 'GET #new' do
    it 'retorna la vista de inicio de sesión' do
      get :new
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    context 'con credenciales válidas' do
      it 'inicia sesión y devuelve mensaje de éxito' do
        post :create, params: { email: usuario.email, password: 'password123' }, format: :json
        expect(response).to have_http_status(:ok)
        expect(session[:user_id]).to eq(usuario.id)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('Inicio de sesión exitoso')
        expect(json_response['data']).to have_key('redirect_to')
        expect(json_response['data']).to have_key('user')
      end
    end

    context 'con credenciales inválidas' do
      it 'devuelve error de autenticación' do
        post :create, params: { email: usuario.email, password: 'wrong_password' }, format: :json
        expect(response).to have_http_status(:unauthorized)
        expect(session[:user_id]).to be_nil
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('Email o contraseña inválidos')
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      session[:user_id] = usuario.id
    end

    it 'cierra la sesión del usuario' do
      delete :destroy, format: :json
      expect(response).to have_http_status(:ok)
      expect(session[:user_id]).to be_nil
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('success')
      expect(json_response['message']).to eq('Sesión cerrada')
    end
  end
end
