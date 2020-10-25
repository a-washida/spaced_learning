class LikesController < ApplicationController
  def create
    @like = current_user.likes.create(share_id: params[:share_id])
    redirect_back(fallback_location: root_path)
  end
end
