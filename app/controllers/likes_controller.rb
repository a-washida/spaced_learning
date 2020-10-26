class LikesController < ApplicationController
  # protect_from_forgery :except => [:create]

  def create
    current_user.likes.create(share_id: params[:share_id])
    count = Like.where(share_id: params[:share_id]).count
    render json: { post: count }
  end
end
