require 'rails_helper'

RSpec.describe "Flujo Integral del Sistema", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:user) do
    create(:usuario, email: "usuario@test.com", password: "password", password_confirmation: "password", rol: "socio")
  end

  it "permite a un usuario iniciar sesión y acceder al tablero" do
    # La raíz muestra la página de login
    visit root_path
    expect(page).to have_content("Iniciar Sesión")
    
    # Completar el formulario de login
    fill_in "Email", with: user.email
    fill_in "Contraseña", with: "password"
    click_button "Entrar"
    
    # Se redirige o se navega manualmente al tablero
    visit tablero_path  # Asegúrate de que 'tablero_path' esté definido en config/routes.rb
    expect(page).to have_content("Tablero")
    expect(page).to have_button("Registrar Ingreso")
  end
end
