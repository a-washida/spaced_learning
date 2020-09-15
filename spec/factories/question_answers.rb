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
      question_answer.question_option = FactoryBot.build(:question_option, question_answer: question_answer)
      question_answer.answer_option = FactoryBot.build(:answer_option, question_answer: question_answer)
    end
  end
end
