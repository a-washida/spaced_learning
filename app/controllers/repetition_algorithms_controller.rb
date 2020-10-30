class RepetitionAlgorithmsController < ApplicationController
  def update
    repetition_algorithm = RepetitionAlgorithm.find(params[:id])
    question_answer = repetition_algorithm.question_answer

    repetition_service = RepetitionAlgorithmService.new(review_params, question_answer, repetition_algorithm, current_user)
    post = repetition_service.execute_repetition_algorithm_considering_conditional_branch(params[:repeat_count], params[:memory_level])

    render json: { post: post }
  end

  # 挙動確認用。アプリリリース時には削除。
  def change_date
    repetition_algorithm = RepetitionAlgorithm.find(params[:id])
    question_answer = repetition_algorithm.question_answer

    repetition_service = ChangeDateService.new(review_params.merge!(change_date: params[:date]), question_answer, repetition_algorithm, current_user)
    post = repetition_service.execute_repetition_algorithm_considering_conditional_branch(params[:repeat_count], params[:memory_level])

    render json: { post: post }
  end
  # //挙動確認用。アプリリリース時には削除。

  private

  def review_params
    params.permit(:interval, :easiness_factor, :repeat_count, :review_count, :memory_level, :id)
  end
end
