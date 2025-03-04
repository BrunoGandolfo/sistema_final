require 'rails_helper'

RSpec.describe 'Authentication', type: :system do
  let(:usuario) { create(:usuario, password: "password", password_confirmation: "password") }

  before do
    driven_by(:chrome_headless)
  end

  describe 'login' do
    it 'permite al usuario iniciar sesión con credenciales válidas' do
      visit login_path
      fill_in "email", with: usuario.email
      fill_in "password", with: "password"
      click_button "Entrar"

      # Esperar explícitamente a la redirección al dashboard
      expect(page).to have_current_path(dashboard_path, wait: 10)

      # Verificar que se muestra la información del usuario usando data-testid
      expect(page).to have_selector("[data-testid='user-info']", text: usuario.nombre, wait: 10)
    end
  end
end
