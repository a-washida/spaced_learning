FactoryBot.define do
  factory :user do
    nickname {Faker::Name.name}
    email {Faker::Internet.free_email}
    password = 'a1234z'
    password {password}
    password_confirmation {password}
  end
end