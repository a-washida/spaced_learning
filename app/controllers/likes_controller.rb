class LikesController < ApplicationController
  def create
    like = current_user.likes.new(share_id: params[:share_id])
    if like.valid?
      like.save
      count = Like.where(share_id: params[:share_id]).count
      render json: { count: count, like_id: like.id, create: 'true' }
    else
      render json: { message: like.errors.full_messages, create: 'false' }
    end
  end

  def destroy
    like = Like.find(params[:id])
    like.destroy
    count = Like.where(share_id: like.share_id).count
    render json: { count: count }
  end
end
