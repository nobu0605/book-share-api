class Api::CommentsController < ApplicationController
  def show
    @comment = Comment.find(params[:id])
    render status: "200", json: @comment
  rescue Exception => e
    render status: "500", json: { message: "Internal Server Error" }
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      comment_attributes = @comment.attributes
      @user = @comment.user
      comment_attributes["username"] = @user.username
      comment_attributes["profile_image"] = @user.profile_image
      return render status: "200", json: comment_attributes
    end

    render status: "400", json: { message: "Failed" }
  rescue => e
    render status: "500", json: { message: "Internal Server Error" }
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.update(content: params[:content])
    render status: "200", json: { message: "Success" }
  rescue Exception => e
    render status: "500", json: { message: "Internal Server Error" }
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    render status: "200", json: { message: "Success" }
  rescue Exception => e
    render status: "500", json: { message: "Internal Server Error" }
  end

  def comment_params
    params.permit(:user_id, :post_id, :content)
  end
end
