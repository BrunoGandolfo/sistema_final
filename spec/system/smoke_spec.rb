require "rails_helper"

RSpec.describe "Smoke Test", type: :system do
  context "cuando el usuario no está autenticado" do
    it "redirige a login desde la raíz" do
      visit root_path
      expect(page).to have_current_path(new_user_session_path)
    end
  end

  context "cuando el usuario está autenticado" do
    let!(:usuario) {
      Usuario.create!(nombre: "Test Usuario", email: "socio1@example.com", password: "password", password_confirmation: "password", rol: "socio")
    }

    before do
      visit new_user_session_path
      fill_in "Email", with: usuario.email
      fill_in "Contraseña", with: "password"
      click_button "Entrar"
    end

    it "redirige al dashboard desde la raíz" do
      visit root_path
      expect(page).to have_current_path(dashboard_path)
    end
  end

  context "operaciones financieras" do
    it "permite la creación de una operación financiera (pendiente)" do
      pending("Implementar creación de operaciones financieras cuando los formularios y flujos estén listos")
      skip "Test pendiente: funcionalidad aún no implementada"
    end
  end
end
