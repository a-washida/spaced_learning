class RepetitionAlgorithm < ApplicationRecord
  belongs_to :question_answer

  with_options presence: true do
    validates :interval, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
    validates :easiness_factor, numericality: { greater_than_or_equal_to: 130, less_than_or_equal_to: 250}
  end
end
