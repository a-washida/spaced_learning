class QuestionOption < ApplicationRecord
  belongs_to :question_answer
  has_one_attached :image
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :font_size
  belongs_to_active_hash :image_size
end
