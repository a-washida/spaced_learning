class Share < ApplicationRecord
  belongs_to :question_answer
  belongs_to :category_second
end
