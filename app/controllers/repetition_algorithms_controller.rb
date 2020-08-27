class RepetitionAlgorithmsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    question_answer = QuestionAnswer.find(params[:question_answer_id])
    repetition_algorithm = question_answer.repetition_algorithm
    repetition_service = RepetitionAlgorithmService.new(review_params, question_answer, repetition_algorithm)
    post = repetition_service.execute_repetition_algorithm_considering_conditional_branch(params[:repeat_count], params[:memory_level])
    render json: { post: post }
  end

  private

  def review_params
    params.permit(:interval, :easiness_factor, :question_answer_id, :repeat_count, :memory_level)
  end
end
