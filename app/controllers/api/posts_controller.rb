class Api::PostsController < ApplicationController
  before_action :authenticate_api_user!

  def index
    @posts =
      Post
        .select(
          "posts.*,
            posts.id as post_id,
            users.*"
        )
        .joins("LEFT JOIN users ON posts.user_id = users.id")
        .order("posts.created_at DESC")
    render status: "200", json: @posts
  rescue Exception => e
    render status: "500", json: { message: "Internal Server Error" }
  end

  def show
    @post = Post.find(params[:id])
    render status: "200", json: @post
  rescue Exception => e
    render status: "500", json: { message: "Internal Server Error" }
  end

  def create
    @post = Post.new(post_params)
    return render status: "200", json: { message: "Success" } if @post.save

    return render status: "400", json: { message: "Failed" }
  rescue Exception => e
    render status: "500", json: { message: "Internal Server Error" }
  end

  def update
    @post = Post.find(params[:id])
    @post.update(content: params[:content])
    render status: "200", json: { message: "Success" }
  rescue Exception => e
    render status: "500", json: { message: "Internal Server Error" }
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    render status: "200", json: { message: "Success" }
  rescue Exception => e
    render status: "500", json: { message: "Internal Server Error" }
  end

  private def post_params
    params.require(:post).permit(:user_id, :content, :post_image)
  end
end
