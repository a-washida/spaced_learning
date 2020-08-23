class QuestionAnswersController < ApplicationController
  before_action :set_group, only: [:index, :show, :edit, :update]
  before_action :set_question_answer, only: [:edit, :update]
  before_action :question_answer_with_option_params, only: :create

  def index
    @question_answers = @group.question_answers.page(params[:page]).per(12)
  end

  def show
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

  def edit
  end

  def update
    if @question_answer.update(nest_params)
      redirect_to group_question_answer_path(@group, @question_answer)
    else
      render 'edit'
    end
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_question_answer
    @question_answer = QuestionAnswer.find(params[:id])
  end

  def question_answer_with_option_params
    params.require(:question_answer_with_option).permit(:question, :question_image, :answer, :answer_image, :question_font_size_id, :question_image_size_id, :answer_font_size_id, :answer_image_size_id).merge(user_id: current_user.id, group_id: params[:group_id])
  end

  def nest_params
    params.require(:question_answer).permit(:question, :answer, 
                                            question_option_attributes: [:image, :font_size_id, :image_size_id, :id], 
                                            answer_option_attributes: [:image, :font_size_id, :image_size_id, :id]
                                            )
  end
end
