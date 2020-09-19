FactoryBot.define do
  factory :group do
    name { Faker::Lorem.characters(number: 10) }
    association :user

    trait :invalid do
      name { nil }
    end

    factory :english, class: Group do
      name { '英語' }
    end

    factory :math, class: Group do
      name { '数学' }
    end
  end
end
