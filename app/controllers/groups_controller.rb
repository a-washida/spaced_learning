class GroupsController < ApplicationController
  # あとでグループを作成したユーザーしかそのグループを見れないように変更する
  def index
    @groups = Group.includes(:user)
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to root_path
    else
      render "index"
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
