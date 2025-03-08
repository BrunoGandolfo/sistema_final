require 'rails_helper'

RSpec.describe 'Authentication', type: :system do
  let(:usuario) { create(:usuario, 
    password: "password", 
    password_confirmation: "password",
    rol: "socio"
  ) }

  before do
    driven_by(:chrome_headless)
  end

  describe 'login' do
    it 'permite al usuario iniciar sesión con credenciales válidas' do
      # Visitar la página principal
      visit root_path
      puts "✓ Visitada la página principal"
      
      # Verificar que estamos en la página principal
      expect(page).to have_selector("[data-testid='nav-login']")
      puts "✓ Encontrado el enlace de login"
      
      # Debug: Mostrar el HTML antes de hacer clic
      puts "HTML antes de hacer clic en login:"
      puts page.html
      
      # Hacer clic en el enlace de login y esperar a que la página cargue
      click_link "Iniciar Sesión"
      puts "✓ Clic en el enlace de login"
      
      # Debug: Mostrar la URL actual y el HTML después del clic
      puts "URL actual: #{page.current_url}"
      puts "HTML después de hacer clic:"
      puts page.html
      
      # Esperar explícitamente a que aparezca el formulario
      using_wait_time(15) do
        expect(page).to have_current_path(new_user_session_path)
        puts "✓ URL correcta verificada"
        expect(page).to have_css("[data-testid='login-form']")
        puts "✓ Formulario encontrado"
      end
      
      # Si llegamos aquí, el formulario está presente
      within("[data-testid='login-form']") do
        fill_in "email", with: usuario.email
        fill_in "password", with: "password"
        click_button "Entrar"
      end

      # Esperar a que se complete la autenticación y redirija al dashboard
      using_wait_time(15) do
        expect(page).to have_current_path(dashboard_path)
        puts "✓ Redirigido al dashboard"
        
        within("[data-testid='user-info']") do
          expect(page).to have_selector("[data-testid='user-name']", text: usuario.nombre)
          expect(page).to have_selector("[data-testid='user-role']", text: "(#{usuario.rol})")
        end
        puts "✓ Información del usuario verificada"
      end
    end
  end
end
