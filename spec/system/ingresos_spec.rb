require 'rails_helper'
RSpec.describe "Flujo de Ingresos", type: :system, js: true do
  before do
    driven_by(:rack_test)
    allow_any_instance_of(ApplicationController).to receive(:api_request?).and_return(false)
  end

  context "usuario con permisos completos (socio)" do
    let(:user) { create(:usuario, rol: "socio", password: "password", password_confirmation: "password") }
    let!(:cliente) { create(:cliente) }
    let!(:tipo_cambio) { create(:tipo_cambio) rescue nil } # En caso de que exista factory

    before do
      visit login_path
      fill_in "email", with: user.email
      fill_in "password", with: "password"
      click_button "Entrar"
      visit dashboard_path
    end

    it "puede crear un nuevo ingreso exitosamente" do
      expect(page).to have_content("Dashboard Financiero", wait: 5)
      initial_count = Ingreso.count

      find('[data-testid="new-ingreso-button"]').click
      expect(page).to have_css('[data-testid="ingreso-modal"]', wait: 5)

      within('[data-testid="ingreso-modal"]') do
        fill_in "ingreso-concepto", with: "Servicio de consultoría"
        fill_in "ingreso-monto", with: 150.0
        select "USD", from: "ingreso-moneda"
        select "Montevideo", from: "ingreso-sucursal"
        select "Jurídica", from: "ingreso-area"
        select cliente.nombre, from: "ingreso-cliente" if page.has_select?("ingreso-cliente")
      end

      click_button "Guardar Ingreso"
      
      expect(page).to have_no_css('[data-testid="ingreso-modal"]', wait: 10)
      expect(page).to have_content("Ingreso registrado con éxito", wait: 5)
      expect(Ingreso.count).to eq(initial_count + 1)
    end
  end

  context "usuario con permisos restringidos (colaborador)" do
    let(:user) { create(:usuario, rol: "colaborador", password: "password", password_confirmation: "password") }
    let!(:cliente) { create(:cliente) }

    before do
      visit login_path
      fill_in "email", with: user.email
      fill_in "password", with: "password"
      click_button "Entrar"
      visit dashboard_path
    end

    it "también puede crear un nuevo ingreso" do
      expect(page).to have_content("Dashboard Financiero", wait: 5)
      initial_count = Ingreso.count

      find('[data-testid="new-ingreso-button"]').click
      expect(page).to have_css('[data-testid="ingreso-modal"]', wait: 5)

      within('[data-testid="ingreso-modal"]') do
        fill_in "ingreso-concepto", with: "Servicio de consultoría"
        fill_in "ingreso-monto", with: 150.0
        select "USD", from: "ingreso-moneda"
        select "Montevideo", from: "ingreso-sucursal"
        select "Jurídica", from: "ingreso-area"
        select cliente.nombre, from: "ingreso-cliente" if page.has_select?("ingreso-cliente")
      end

      click_button "Guardar Ingreso"
      
      expect(page).to have_no_css('[data-testid="ingreso-modal"]', wait: 10)
      expect(page).to have_content("Ingreso registrado con éxito", wait: 5)
      expect(Ingreso.count).to eq(initial_count + the)
    end
  end

  context "usuario sin autenticación" do
    it "es redirigido al login" do
      visit dashboard_path
      expect(page).to have_current_path(login_path)
      expect(page).to have_content("Iniciar Sesión")
    end
  end
end
