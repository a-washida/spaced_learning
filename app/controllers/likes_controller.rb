class LikesController < ApplicationController

  def create
    like = current_user.likes.create(share_id: params[:share_id])
    count = Like.where(share_id: params[:share_id]).count
    render json: { count: count, like_id: like.id }
  end

  def destroy
    like = Like.find(params[:id])
    like.destroy
    count = Like.where(share_id: like.share_id).count
    render json: { count: count }
  end
  
end
