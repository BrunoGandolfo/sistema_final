FactoryBot.define do
  factory :proveedor do
    sequence(:nombre) { |n| "Proveedor #{n}" }
  end
end
