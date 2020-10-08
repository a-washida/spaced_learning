class QuestionAnswer < ApplicationRecord
  validate :question_text_or_image_indispensable
  validate :answer_text_or_image_indispensable
  with_options presence: true do
    validates :display_date
    with_options numericality: true do
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

  # 問題の、テキストまたは画像どちらかが必須という制限をつけるカスタムメソッド
  def question_text_or_image_indispensable
    return if question.present? || question_option.image.present?

    errors.add(:question, 'はテキストもしくは画像の入力が必須です')
  end

  # 解答の、テキストまたは画像どちらかが必須という制限をつけるカスタムメソッド
  def answer_text_or_image_indispensable
    return if answer.present? || answer_option.image.present?

    errors.add(:answer, 'はテキストもしくは画像の入力が必須です')
  end
end
