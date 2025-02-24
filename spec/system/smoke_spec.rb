require 'rails_helper'

RSpec.describe 'Smoke Test', type: :system do
  before do
    driven_by(:rack_test)  # Cambia a :chrome_headless si necesitas soporte para JavaScript
  end

  it 'carga la página principal con los enlaces de navegación' do
    visit root_path
    expect(page).to have_link('Iniciar Sesión', href: login_path)
    expect(page).to have_link('Registrarse', href: signup_path)
  end

  it 'registra un nuevo usuario exitosamente' do
    visit signup_path
    fill_in 'Nombre', with: 'Test User'
    fill_in 'Email', with: 'testuser@example.com'
    fill_in 'Contraseña', with: 'password'
    fill_in 'Confirmación de Contraseña', with: 'password'
    click_button 'Crear Cuenta'
    # Verificamos que la respuesta incluya el mensaje de éxito (en formato JSON en este caso)
    expect(page.body).to include('Usuario registrado exitosamente')
  end

  it 'inicia sesión con un usuario existente correctamente' do
    user = Usuario.create!(
      nombre: 'Test User',
      email: 'testlogin@example.com',
      password: 'password',
      password_confirmation: 'password',
      rol: 'colaborador'
    )
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Contraseña', with: 'password'
    click_button 'Entrar'
    expect(page.body).to include('Inicio de sesión exitoso')
  end

  it 'rechaza el inicio de sesión con credenciales inválidas' do
    visit login_path
    fill_in 'Email', with: 'nonexistent@example.com'
    fill_in 'Contraseña', with: 'wrongpassword'
    click_button 'Entrar'
    expect(page.body).to include('Email o contraseña inválidos')
  end

  it 'simula la creación de operaciones financieras (pendiente)' do
    skip "Implementar pruebas para ingresos, gastos, retiros y distribuciones cuando se desarrollen los formularios y previews"
    # Aquí se agregarán los pasos para simular la creación y confirmación de operaciones financieras.
  end
end
