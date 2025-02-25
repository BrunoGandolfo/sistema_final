FactoryBot.define do
  factory :usuario do
    sequence(:nombre) { |n| "Usuario de Prueba #{n}" }
    sequence(:email) { |n| "usuario#{n}@example.com" }
    password { "password" }
    rol { "admin" }  # Asignamos un valor predeterminado para el rol
  end
end
