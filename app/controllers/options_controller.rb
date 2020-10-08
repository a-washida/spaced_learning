class OptionsController < ApplicationController
  before_action :set_option, only: [:edit, :update]

  def edit
  end

  def update
    if @option.update(option_params)
      redirect_to root_path, notice: '設定を変更しました'
    else
      render 'edit'
    end
  end

  private

  def set_option
    @option = Option.find(params[:id])
  end

  def option_params
    params.require(:option).permit(:interval_of_ml1, :interval_of_ml2, :interval_of_ml3, :interval_of_ml4, :upper_limit_of_ml1, :upper_limit_of_ml2, :easiness_factor)
  end
end
