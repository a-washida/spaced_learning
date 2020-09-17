FactoryBot.define do
  factory :question_answer do
    question { Faker::Lorem.characters(number: 10) }
    answer { Faker::Lorem.characters(number: 10) }
    display_date { Date.today }
    memory_level { 0 }
    repeat_count { 0 }
    association :user
    association :group

    after(:build) do |question_answer|
      question_answer.question_option = FactoryBot.build(:question_option, :with_image)
      question_answer.answer_option = FactoryBot.build(:answer_option, :with_image)
      question_answer.repetition_algorithm = FactoryBot.build(:repetition_algorithm)
    end

    # font_size_idとimage_size_idを変更した状態のテストデータ
    trait :size_change do
      after(:build) do |question_answer|
        question_answer.question_option = FactoryBot.build(:question_option, :with_image, font_size_id: 8, image_size_id: 6)
        question_answer.answer_option = FactoryBot.build(:answer_option, :with_image, font_size_id: 8, image_size_id: 6)
      end
    end

    # 画像を添付しない場合のテストデータ
    trait :no_image do  
      after(:build) do |question_answer|
        question_answer.question_option = FactoryBot.build(:question_option)
        question_answer.answer_option = FactoryBot.build(:answer_option)
      end
    end
  end
end
