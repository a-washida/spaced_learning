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
      Record.record_create_count
    end
    redirect_to new_group_question_answer_path(@group)
  rescue StandardError => e
    render 'new'
  end

  def edit
  end

  def update
    if @question_answer.update(nested_form_params.except(:display_date, :display_year, :memory_level, :repeat_count))
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

  def review
    # where内の条件：display_yearが今年かつdisplay_dateが今日までの場合、またはdisplay_yearが今年よりも以前の場合
    @question_answers = @group.question_answers.where('display_year = ? AND display_date <= ?', Date.today.year, Date.today.yday)
                              .or(@group.question_answers.where('display_year < ?', Date.today.year))
                              .page(params[:page]).per(12)
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
          .merge(display_date: Date.today.yday, display_year: Date.today.year, memory_level: 0, repeat_count: 0, user_id: current_user.id, group_id: params[:group_id])
  end
end
