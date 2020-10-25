class Share < ApplicationRecord
  belongs_to :question_answer
  belongs_to :category_second
  has_many :likes
  has_many :liked_users, through: :likes, source: :user
end
