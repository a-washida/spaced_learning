class QuestionAnswerWithOption
  include ActiveModel::Model
  # user_id必要？
  attr_accessor :question, :question_image, :answer, :answer_image, :question_font_size_id, :question_image_size_id, :answer_font_size_id, :answer_image_size_id, :user_id, :group_id

  validate :question_text_or_image_indispensable
  validate :answer_text_or_image_indispensable
  with_options presence: true do
    with_options numericality: { only_integer: true } do
      validates :question_font_size_id
      validates :question_image_size_id
      validates :answer_font_size_id
      validates :answer_image_size_id
    end
  end

  # 問題エリアのテキストか画像両方空欄だとerrorが出るカスタムバリデーション
  def question_text_or_image_indispensable
    return if question.present? || question_image.present?

    errors.add(:question, 'text or image is indispensable')
  end

  # 解答エリアのテキストか画像両方空欄だとerrorが出るカスタムバリデーション
  def answer_text_or_image_indispensable
    return if answer.present? || answer_image.present?

    errors.add(:answer, 'text or image is indispensable')
  end

  def save
    question_answer = QuestionAnswer.create(question: question, answer: answer, display_date: Date.today.yday, memory_level: 0, repeat_count: 0, user_id: user_id, group_id: group_id)
    QuestionOption.create(font_size_id: question_font_size_id, image_size_id: question_image_size_id, question_answer_id: question_answer.id, image: question_image)
    AnswerOption.create(font_size_id: answer_font_size_id, image_size_id: answer_image_size_id, question_answer_id: question_answer.id, image: answer_image)
  end
end
