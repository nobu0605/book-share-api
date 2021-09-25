class Api::LikesController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    @like = @user.likes.create(post_id: params[:post_id])
    render status: "200", json: { message: "Success" }
  rescue Exception => e
    render status: "500", json: { message: "Internal Server Error" }
  end

  def destroy
    @like = Like.find_by(post_id: params[:post_id], user_id: params[:user_id])
    @like.destroy
    render status: "200", json: { message: "Success" }
  rescue Exception => e
    render status: "500", json: { message: "Internal Server Error" }
  end
end
