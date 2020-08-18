class QuestionAnswersController < ApplicationController

  def new
    @group = current_user.groups.find(params[:group_id])
    @question_answer = QuestionAnswer.new
  end

  def create
  end

end
