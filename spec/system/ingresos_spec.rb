require 'rails_helper'

RSpec.describe "Flujo de Ingresos", type: :system do
  before do
    driven_by(:rack_test)
  end

  context "usuario con permisos completos (socio)" do
    let(:user) { create(:usuario, rol: "socio", password: "password", password_confirmation: "password") }
    
    before do
      visit login_path
      fill_in "Email", with: user.email
      fill_in "Password", with: "password"
      click_button "Iniciar sesión"
      # Suponiendo que después de iniciar sesión se redirige a dashboard
      visit dashboard_path
    end

    it "puede crear un nuevo ingreso exitosamente" do
      # Ajusta el texto del botón según el contenido real de la vista
      expect(page).to have_button("Registrar Ingreso")
      click_button "Registrar Ingreso"
      
      # Completar el formulario (ajusta los labels según la vista real)
      fill_in "Monto", with: 150.0
      fill_in "Moneda", with: "USD"
      fill_in "Fecha", with: Date.today.to_s
      fill_in "Sucursal", with: "Montevideo"
      fill_in "Área", with: "Consultoría"
      fill_in "Concepto", with: "Servicio de consultoría"
      click_button "Crear Ingreso"
      
      expect(page).to have_content("Ingreso creado correctamente")
      # Si el driver no soporta screenshots, se usa rescue nil
      page.save_screenshot("tmp/screenshots/ingreso_exitoso.png") rescue nil
    end
  end

  context "usuario con permisos restringidos (colaborador)" do
    let(:user) { create(:usuario, rol: "colaborador", password: "password", password_confirmation: "password") }
    
    before do
      visit login_path
      fill_in "Email", with: user.email
      fill_in "Password", with: "password"
      click_button "Iniciar sesión"
      visit dashboard_path
    end

    it "también puede crear un nuevo ingreso" do
      expect(page).to have_button("Registrar Ingreso")
      click_button "Registrar Ingreso"
      
      fill_in "Monto", with: 150.0
      fill_in "Moneda", with: "USD"
      fill_in "Fecha", with: Date.today.to_s
      fill_in "Sucursal", with: "Montevideo"
      fill_in "Área", with: "Consultoría"
      fill_in "Concepto", with: "Servicio de consultoría"
      click_button "Crear Ingreso"
      
      expect(page).to have_content("Ingreso creado correctamente")
      page.save_screenshot("tmp/screenshots/ingreso_colaborador.png") rescue nil
    end
  end

  context "usuario sin autenticación" do
    it "es redirigido al login" do
      visit dashboard_path
      expect(page).to have_current_path(new_user_session_path)
      page.save_screenshot("tmp/screenshots/ingreso_no_autenticado.png") rescue nil
    end
  end
end
