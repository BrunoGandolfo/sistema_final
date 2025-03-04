require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  describe 'GET #new' do
    it 'retorna la vista de registro' do
      get :new
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    context 'con parámetros válidos' do
      let(:valid_params) do
        {
          nombre: 'Usuario Prueba',
          email: 'test@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        }
      end

      it 'crea un nuevo usuario con rol colaborador y establece la sesión' do
        expect {
          post :create, params: valid_params, format: :json
        }.to change(Usuario, :count).by(1)
        
        expect(response).to have_http_status(:created)
        # Verifica que se estableció la sesión
        expect(session[:user_id]).not_to be_nil
        # Verifica el rol asignado
        user = Usuario.last
        expect(user.rol).to eq('colaborador')
        # Verifica la respuesta JSON
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Usuario registrado exitosamente')
        expect(json_response).to have_key('user')
      end
    end

    context 'con parámetros inválidos' do
      let(:invalid_params) do
        {
          nombre: '',
          email: 'invalid-email',
          password: 'short',
          password_confirmation: 'different'
        }
      end

      it 'no crea un usuario y muestra errores' do
        expect {
          post :create, params: invalid_params, format: :json
        }.not_to change(Usuario, :count)
        
        expect(response).to have_http_status(:unprocessable_entity)
        # Verifica que no se estableció la sesión
        expect(session[:user_id]).to be_nil
        # Verifica la respuesta JSON
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('errors')
      end
    end
  end
end
