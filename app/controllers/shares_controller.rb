class SharesController < ApplicationController
  before_action :set_category_second, only: :index
  before_action :set_question_answer, only: [:create, :destroy, :import]
  before_action :move_to_root_if_different_user, only: [:create, :destroy]
  before_action :move_to_root_if_same_user, only: :import
  before_action :set_session, only: [:create, :destroy, :import]

  def index
    @shares = Share.where(category_second_id: params[:category_second_id]).page(params[:page]).per(10)
    @category_seconds = CategorySecond.all
  end

  def create
    @share_category = ShareCategory.new(share_params)
    if @share_category.valid?
      @share_category.save
      redirect_to back_to_specific_question_position, notice: '問題の共有に成功しました'
    else
      redirect_to back_to_specific_question_position, alert: @share_category.errors.full_messages
    end
  end

  def destroy
    share = @question_answer.share
    if share.destroy
      redirect_to back_to_specific_question_position, notice: '共有の解除に成功しました'
    else
      redirect_to back_to_specific_question_position, alert: '共有の解除に失敗しました'
    end
  end

  def import
    @question_answer_dup = QuestionAnswer.new(dup_params)
    ActiveRecord::Base.transaction do
      @question_answer_dup.save!
      attach_dup_image_to_question_option if @question_answer.question_option.image.attached?
      attach_dup_image_to_answer_option if @question_answer.answer_option.image.attached?
      RepetitionAlgorithm.create!(interval: 0, easiness_factor: current_user.option.easiness_factor, question_answer_id: @question_answer_dup.id)
    end
    redirect_to back_to_specific_question_position, notice: "問題を「#{Group.find(params[:group_id]).name}」にインポートしました"
  rescue StandardError => e
    redirect_to back_to_specific_question_position, alert: '問題のインポートに失敗しました'
  end

  private

  def set_category_second
    @category_second = CategorySecond.find(params[:category_second_id])
  end

  def set_question_answer
    @question_answer = QuestionAnswer.find(params[:question_answer_id])
  end

  def set_session
    session[:qa_id] = @question_answer.id
  end

  def share_params
    params.require(:share_category).permit(:category_first_id, :category_second).merge(question_answer_id: params[:question_answer_id])
  end

  # 一つ前のページの、特定の問題の位置に戻るためのurlを返すメソッド
  def back_to_specific_question_position
    request.referer + "#link-#{@question_answer.id}" || root_path
  end

  def dup_params
    { question: @question_answer.question, 
      answer: @question_answer.answer, 
      display_date: Date.today, 
      memory_level: 0, 
      repeat_count: 0, 
      user_id: current_user.id, 
      group_id: params[:group_id],
      question_option_attributes: { font_size_id: @question_answer.question_option.font_size_id, 
                                    image_size_id: @question_answer.question_option.image_size_id },
      answer_option_attributes:   { font_size_id: @question_answer.answer_option.font_size_id, 
                                    image_size_id: @question_answer.answer_option.image_size_id }
    }
  end

  def move_to_root_if_different_user
    redirect_to root_path unless current_user.id == @question_answer.user.id
  end

  def move_to_root_if_same_user
    redirect_to root_path if current_user.id == @question_answer.user.id
  end

  def attach_dup_image_to_question_option
    @question_answer_dup.question_option.image.attach io: StringIO.new(@question_answer.question_option.image.download),
                                                      filename: @question_answer.question_option.image.filename,
                                                      content_type: @question_answer.question_option.image.content_type 
  end

  def attach_dup_image_to_answer_option
    @question_answer_dup.answer_option.image.attach io: StringIO.new(@question_answer.answer_option.image.download),
                                                      filename: @question_answer.answer_option.image.filename,
                                                      content_type: @question_answer.answer_option.image.content_type 
  end
end
