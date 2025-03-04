require 'rails_helper'
RSpec.describe "Flujo Integral del Sistema", type: :system do
  before do
    # Usar el driver más simple, que no tiene problemas con los headers
    driven_by(:rack_test)
    
    # Para evitar que api_request? detecte nuestras pruebas como API
    allow_any_instance_of(ApplicationController).to receive(:api_request?).and_return(false)
  end
  
  let!(:user) do
    create(:usuario, email: "usuario@test.com", password: "password", password_confirmation: "password", rol: "socio")
  end
  
  it "permite a un usuario iniciar sesión y acceder al dashboard" do
    # Ir directamente a la página de login
    visit login_path
    
    # Verificar que estamos en la página de login
    expect(page).to have_content("Iniciar Sesión")
    
    # Completar el formulario
    fill_in "email", with: user.email
    fill_in "password", with: "password"
    click_button "Entrar"
    
    # Ahora deberíamos ser redirigidos al dashboard
    expect(page).to have_current_path(dashboard_path)
    
    # Verificar que estamos en el dashboard
    expect(page).to have_content("Dashboard") 
  end
end
