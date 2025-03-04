module CapybaraHelpers
  def disable_api_detection
    allow_any_instance_of(ApplicationController).to receive(:api_request?).and_return(false)
  end
  
  def fill_login_email(email)
    fill_in 'email', with: email
  end
  
  def fill_login_password(password)
    fill_in 'password', with: password
  end
  
  def login_as(user)
    disable_api_detection
    visit login_path
    fill_in "email", with: user.email
    fill_in "password", with: user.password || "password"
    click_button "Entrar"
    expect(page).to have_current_path(dashboard_path)
  end
end

RSpec.configure do |config|
  config.include CapybaraHelpers, type: :system
  
  # Configuración global para todas las pruebas de sistema
  config.before(:each, type: :system) do
    driven_by(:rack_test)
    disable_api_detection if respond_to?(:disable_api_detection)
  end
end
