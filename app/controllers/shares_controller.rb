class SharesController < ApplicationController
  before_action :set_question_answer, only: [:create, :destroy]
  before_action :set_session, only: [:create, :destroy]

  def create
    @share_category = ShareCategory.new(share_params)
    if @share_category.valid?
      @share_category.save
      redirect_to back_to_specific_question_position, notice: '問題の共有に成功しました'
    else
      redirect_to back_to_specific_question_position, alert: '問題の共有に失敗しました'
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

  private

  def set_question_answer
    @question_answer = QuestionAnswer.find(params[:question_answer_id])
  end

  def set_session
    session[:qa_id] = @question_answer.id
  end

  def share_params
    params.require(:share_category).permit(:category_first_id, :category_second).merge(question_answer_id: params[:question_answer_id])
  end

  # 問題管理ページの、特定の問題の位置に戻るためのurlを返すメソッド
  def back_to_specific_question_position
    request.referer + "#link-#{@question_answer.id}" || root_path
  end
end
