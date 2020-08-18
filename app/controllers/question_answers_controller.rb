class QuestionAnswersController < ApplicationController
  before_action :set_group, only: [:new, :create]
  before_action :question_params, only: :create

  def new
    @question_answer = QuestionAnswer.new
  end

  def create
    @question_answer = QuestionAnswer.new(question_params)
    if @question_answer.save
      redirect_to new_group_question_answer_path(@group)
    else
      render 'new'
    end
  end

  private

  def question_params
    params.require(:question_answer).permit(:question, :answer).merge(display_date: Date.today.yday, memory_level: 0, repeat_count: 0, user_id: current_user.id, group_id: params[:group_id])
  end

  def set_group
    @group = current_user.groups.find(params[:group_id])
  end
end
