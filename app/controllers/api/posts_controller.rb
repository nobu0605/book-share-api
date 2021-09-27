class Api::PostsController < ApplicationController
  before_action :authenticate_api_user!

  def get_posts
    page = params[:page].to_i
    limit = 20
    offset = page * limit

    @posts =
      Post
        .select(
          " posts.id,
            posts.content,
            posts.post_image,
            posts.user_id,
            users.profile_image,
            users.username"
        )
        .joins("LEFT JOIN users ON posts.user_id = users.id")
        .order("posts.created_at DESC")
        .limit(limit)
        .offset(offset)

    @user = User.find(params["auth_user_id"])

    posts = []
    @posts.each do |post|
      post_attributes = post.attributes
      post_attributes["liked_count"] = post.liked_users.count
      post_attributes["already_liked"] = @user.already_liked?(post)
      posts.push(post_attributes)
    end

    render status: "200", json: posts
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
    ActiveRecord::Base.transaction do
      post_params = { user_id: params[:user_id], content: params[:content] }
      @post = Post.new(post_params)

      if @post.save
        if params[:post_picture].present?
          file = params[:post_picture]
          image_name = "#{@post.id}-#{file.original_filename}"
          File.open("public/post-img/#{image_name}", "wb") do |f|
            f.write(file.read)
          end
          @post.update(post_image: image_name)
        end

        post_attributes = @post.attributes
        @user = @post.user
        post_attributes["profile_image"] = @user.profile_image
        post_attributes["username"] = @user.username
        post_attributes["liked_count"] = @post.liked_users.count
        post_attributes["already_liked"] = @user.already_liked?(@post)

        return render status: "200", json: post_attributes
      end
      render status: "400", json: { message: "Failed" }
    end
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
end
