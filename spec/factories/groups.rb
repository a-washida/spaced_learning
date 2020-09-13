FactoryBot.define do
  factory :group do
    name {'グループ'}
    association :user
  end
end
