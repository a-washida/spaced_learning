FactoryBot.define do
  factory :option do
    interval_of_ml1 { 2 }
    interval_of_ml2 { 3 }
    interval_of_ml3 { 4 }
    interval_of_ml4 { 5 }
    upper_limit_of_ml1 { 3 }
    upper_limit_of_ml2 { 7 }
    easiness_factor { 250 }
    association :user
  end
end
