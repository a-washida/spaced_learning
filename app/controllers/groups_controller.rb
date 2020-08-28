class GroupsController < ApplicationController
  before_action :set_group, only: [:update, :destroy]
  # before_action追加する
  # DRYも解消するべきかも
  # エラーハンドリング見直した方が良さそう(create, update両方)
  # create失敗時のエラーメッセージはJavaScript必要になりそう
  def index
    @groups = current_user.groups
    @group = Group.new
    @date_and_records = Record.get_weekly_date_and_record
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to root_path
    else
      @groups = current_user.groups
      render 'index'
    end
  end

  def update
    @group.update(group_params)
    render json: { post: @group }
  end

  def destroy
    if @group.destroy
      redirect_to root_path
    else
      # renderで書くべき？
      redirect_to group_question_answers_path(@group)
    end
  end

  private

  def group_params
    params.require(:group).permit(:name).merge(user_id: current_user.id)
  end

  def set_group
    @group = Group.find(params[:id])
  end
end
