class CategorySecondsController < ApplicationController
  def search
    result = CategorySecond.where(category_first_id: params[:category_first])
    render json: {result: result }
  end
end
