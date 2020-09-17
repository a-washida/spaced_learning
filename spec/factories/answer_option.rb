FactoryBot.define do
  factory :answer_option do
    font_size_id { 6 }
    image_size_id { 4 }

    # 画像を添付する場合のテストデータ
    trait :with_image do
      after(:build) do |item|
        item.image.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png')
      end
    end
  end
end
