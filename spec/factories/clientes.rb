FactoryBot.define do
  factory :cliente do
    sequence(:nombre) { |n| "Cliente #{n}" }
  end
end
