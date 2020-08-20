class QuestionAnswerWithOption

  include ActiveModel::Model
  # user_id必要？
  attr_accessor :question, :question_image, :answer, :answer_image, :question_font_size_id, :question_image_size_id, :answer_font_size_id, :answer_image_size_id, :user_id, :group_id

  # imageかquestion両方空欄だとerrorが出るカスタムバリデーション
  # validate :text_or_image_indispensable

  # def text_or_image_indispensable
  #   return if question.present? || question_image.present?
  #   errors.add(:question, "is absent")
  # end

  def save
    question_answer = QuestionAnswer.create(question: question, answer: answer, display_date: Date.today.yday, memory_level: 0, repeat_count: 0, user_id: user_id, group_id: group_id)
    QuestionOption.create(font_size_id: question_font_size_id, image_size_id: question_image_size_id, question_answer_id: question_answer.id, image: question_image)
    AnswerOption.create(font_size_id: answer_font_size_id, image_size_id: answer_image_size_id, question_answer_id: question_answer.id, image: answer_image)
  end
end