class OptionsController < ApplicationController
  before_action :set_option, only: [:edit, :update]

  def edit
  end

  def update
  end

  private
  
  def set_option
    @option = Option.find(params[:id])
  end
end
