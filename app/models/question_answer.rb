class QuestionAnswer < ApplicationRecord
  with_options presence: true do
    validates :question
    validates :answer

    with_options numericality: true do
      validates :display_date
      validates :memory_level
      validates :repeat_count
    end
  end

  belongs_to :user
  belongs_to :group
  has_one :question_option
  has_one :answer_option
end
