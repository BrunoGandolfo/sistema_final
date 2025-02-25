module AuthenticationHelpers
  def sign_in(usuario)
    # Establecer la sesión directamente para pruebas que no requieren interacción con la UI
    page.driver.browser.rack_mock_session.cookie_jar['rack.session'] = { user_id: usuario.id }
  end
  
  def login_via_form(usuario)
    visit new_user_session_path
    fill_in "Email", with: usuario.email
    fill_in "Password", with: "password"
    click_button "Entrar"
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers, type: :system
  config.include AuthenticationHelpers, type: :feature
end
