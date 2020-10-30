class CategorySecondsController < ApplicationController
  def index
    @category_seconds = CategorySecond.all
  end

  def search
    result = CategorySecond.where(category_first_id: params[:category_first])
    render json: { result: result }
  end
end
