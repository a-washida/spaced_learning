FactoryBot.define do
  factory :question_option do
    font_size_id { 6 }
    image_size_id { 4 }

    after(:build) do |item|
      item.image.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png')
    end
  end
end
