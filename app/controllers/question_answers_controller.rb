class QuestionAnswersController < ApplicationController
  before_action :question_answer_with_option_params, only: :create

  def index
  end

  def show
    @group = Group.find(params[:group_id])
    # 恐らくここ要変更
    @question_answer = QuestionAnswer.find(params[:id])
  end

  def new
    @question_answer_with_option = QuestionAnswerWithOption.new
  end

  def create
    @question_answer_with_option = QuestionAnswerWithOption.new(question_answer_with_option_params)
    if @question_answer_with_option.valid?
      @question_answer_with_option.save
      redirect_to new_group_question_answer_path(Group.find(params[:group_id]))
    else
      render 'new'
    end
  end

  private

  def question_answer_with_option_params
    params.require(:question_answer_with_option).permit(:question, :question_image, :answer, :answer_image, :question_font_size_id, :question_image_size_id, :answer_font_size_id, :answer_image_size_id).merge(user_id: current_user.id, group_id: params[:group_id])
  end
end
