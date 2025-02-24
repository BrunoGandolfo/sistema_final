require 'rails_helper'

RSpec.describe 'Authentication', type: :system do
  before do
    driven_by(:rack_test)  # Cambia a :chrome_headless si necesitas soporte para JavaScript
  end

  it 'permite al usuario ver el formulario de Login' do
    visit login_path
    expect(page).to have_content("Iniciar Sesión")
    expect(page).to have_button("Entrar")
  end

  it 'permite al usuario ver el formulario de Registro' do
    visit signup_path
    expect(page).to have_content("Registrarse")
    expect(page).to have_button("Crear Cuenta")
  end
end
