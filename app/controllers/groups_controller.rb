class GroupsController < ApplicationController
  before_action :group_params, only: [:create, :update]
  # before_action追加する
  # DRYも解消するべきかも
  # エラーハンドリング見直した方が良さそう(create, update両方)
  # create失敗時のエラーメッセージはJavaScript必要になりそう
  def index
    @groups = current_user.groups
    @group = Group.new
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
    group = Group.find(params[:id])
    group.update(group_params)
    render json: { post: group }
  end

  private

  def group_params
    params.require(:group).permit(:name).merge(user_id: current_user.id)
  end
end
