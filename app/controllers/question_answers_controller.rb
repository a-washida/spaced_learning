class QuestionAnswersController < ApplicationController
  before_action :set_group, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :set_question_answer, only: [:edit, :update, :destroy]

  def index
    @question_answers = @group.question_answers.page(params[:page]).per(12)
  end

  def show
    # 恐らくここ要変更
    @question_answer = QuestionAnswer.find(params[:id])
  end

  def new
    @question_answer = QuestionAnswer.new
    @question_answer.build_question_option
    @question_answer.build_answer_option
  end

  def create
    @question_answer = QuestionAnswer.new(nest_params)
    if @question_answer.save
      redirect_to new_group_question_answer_path(@group)
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

  def destroy
    if @question_answer.destroy
      redirect_to group_question_answers_path(@group)
    else
      reder 'show'
    end
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_question_answer
    @question_answer = QuestionAnswer.find(params[:id])
  end

  def nest_params
    params.require(:question_answer).permit(:question, :answer,
                                            question_option_attributes: [:image, :font_size_id, :image_size_id, :id],
                                            answer_option_attributes: [:image, :font_size_id, :image_size_id, :id]).merge(display_date: Date.today.yday, memory_level: 0, repeat_count: 0, user_id: current_user.id, group_id: params[:group_id])
  end
end
