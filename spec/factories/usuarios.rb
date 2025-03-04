FactoryBot.define do
  factory :usuario do
    nombre { "Usuario de Prueba" }
    email { "test#{rand(1000)}@example.com" }
    password { "password" }
    password_confirmation { password }  # Usará el mismo valor que password aunque cambie
    rol { "colaborador" }
  end
end
