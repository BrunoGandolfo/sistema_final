FactoryBot.define do
  factory :usuario do
    sequence(:nombre) { |n| "Usuario de Prueba #{n}" }
    sequence(:email) { |n| "usuario#{n}@example.com" }
    password { "password" }
    rol { "admin" }  # Asignamos un valor predeterminado para el rol

    trait :admin do
      rol { "admin" }
    end

    trait :socio do
      rol { "socio" }
    end

    trait :colaborador do
      rol { "colaborador" }
    end
  end
end
