class QuestionAnswersController < ApplicationController
  before_action :set_group
  before_action :set_question_answer, only: [:show, :edit, :update, :destroy]

  def index
    @question_answers = @group.question_answers.page(params[:page]).per(12)
  end

  def show
  end

  def new
    @question_answer = QuestionAnswer.new
    @question_answer.build_question_option
    @question_answer.build_answer_option
  end

  def create
    @question_answer = QuestionAnswer.new(nested_form_params)
    ActiveRecord::Base.transaction do
      # 次の一行で3つのテーブル: question_answers, question_options, answer_optionsに同時保存
      @question_answer.save!
      # repetition_algorithmsテーブルに保存
      RepetitionAlgorithm.create!(interval: 0, easiness_factor: 200, question_answer_id: @question_answer.id)
      # recordsテーブルに保存or更新
      Record.record_create_count(current_user.id)
    end
    redirect_to new_group_question_answer_path(@group)
  rescue StandardError => e
    @question_answer = e.record
    render 'new'
  end

  def edit
  end

  def update
    if @question_answer.update(nested_form_params.except(:display_date, :memory_level, :repeat_count))
      redirect_to group_question_answer_path(@group, @question_answer)
    else
      render 'edit'
    end
  end

  def destroy
    if @question_answer.destroy
      # redirect_to group_question_answers_path(@group)
      redirect_back(fallback_location: root_path)
    else
      reder 'show'
    end
  end

  def review
    @question_answers = @group.question_answers.where('display_date <= ?', Date.today).page(params[:page]).per(12)
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_question_answer
    @question_answer = QuestionAnswer.find(params[:id])
  end

  def nested_form_params
    params.require(:question_answer).permit(:question, :answer,
                                            question_option_attributes: [:image, :font_size_id, :image_size_id, :id],
                                            answer_option_attributes: [:image, :font_size_id, :image_size_id, :id])
          .merge(display_date: Date.today, memory_level: 0, repeat_count: 0, user_id: current_user.id, group_id: params[:group_id])
  end
end
