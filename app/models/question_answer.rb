class QuestionAnswer < ApplicationRecord
  validate :question_text_or_image_indispensable
  validate :answer_text_or_image_indispensable
  with_options presence: true do
    with_options numericality: true do
      validates :display_date
      validates :memory_level
      validates :repeat_count
    end
  end

  belongs_to :user
  belongs_to :group
  has_one :question_option, dependent: :destroy
  has_one :answer_option, dependent: :destroy
  has_one :repetition_algorithm, dependent: :destroy

  accepts_nested_attributes_for :question_option
  accepts_nested_attributes_for :answer_option

  private

  def question_text_or_image_indispensable
    return if question.present? || question_option.image.present?

    errors.add(:question, 'text or image is indispensable')
  end

  def answer_text_or_image_indispensable
    return if answer.present? || answer_option.image.present?

    errors.add(:answer, 'text or image is indispensable')
  end
end
