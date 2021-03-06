class GroupsController < ApplicationController
  before_action :set_group, only: [:update, :destroy]
  before_action :move_to_root_if_different_user, only: [:update, :destroy]

  def index
    @groups = current_user.groups
    @group = Group.new
    @date_and_records = Record.get_weekly_date_and_record(current_user)
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to root_path
    else
      @groups = current_user.groups
      @date_and_records = Record.get_weekly_date_and_record(current_user)
      render 'index'
    end
  end

  def update
    if @group.update(group_params)
      render json: { post: @group, update: 'true' }
    else
      render json: { post: @group.errors.full_messages, update: 'false' }
    end
  end

  def destroy
    if @group.destroy
      redirect_to root_path
    else
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

  def move_to_root_if_different_user
    redirect_to root_path unless current_user.id == @group.user.id
  end
end
