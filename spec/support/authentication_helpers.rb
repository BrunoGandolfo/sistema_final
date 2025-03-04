module AuthenticationHelpers
  def sign_in(usuario)
    if page.driver.browser.respond_to?(:rack_mock_session)
      # Para drivers que no interactúan con la UI (rack_test)
      page.driver.browser.rack_mock_session.cookie_jar['rack.session'] = {
        user_id: usuario.id
      }
    else
      # Para drivers que interactúan con la UI (Selenium)
      visit new_user_session_path
      fill_in "email", with: usuario.email
      fill_in "password", with: usuario.password
      click_button "Entrar"
      expect(page).to have_content(usuario.nombre)
    end
  end

  def sign_out
    if page.driver.browser.respond_to?(:rack_mock_session)
      page.driver.browser.rack_mock_session.cookie_jar['rack.session'] = {}
    else
      visit root_path
      click_link "Cerrar Sesión"
    end
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers, type: :system
  config.include AuthenticationHelpers, type: :feature
end
