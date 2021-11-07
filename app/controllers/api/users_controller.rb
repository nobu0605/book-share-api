class Api::UsersController < ApplicationController
  before_action :authenticate_api_user!

  def get_users
    @user = User.all
    return render status: "400", json: "User not found" if !@user

    render status: "200", json: @user
  rescue Exception => e
    render status: "500", json: { message: "Internal Server Error" }
  end

  def get_user
    @user = User.find_by(uid: params["uid"])
    return render status: "400", json: "User not found" if !@user

    render status: "200", json: @user
  rescue Exception => e
    render status: "500", json: { message: "Internal Server Error" }
  end

  def update_user
    @user = User.find(params[:user_id])
    @user.update(
      username: params[:username],
      self_introduction: params[:self_introduction]
    )

    if params[:profile_image].present?
      file = params[:profile_image]
      image_name = "#{@user.id}-#{file.original_filename}"
      File.open("public/profile-img/#{image_name}", "wb") do |f|
        f.write(file.read)
      end
      @user.update(profile_image: image_name)
    end

    render status: "200", json: @user
  rescue Exception => e
    render status: "500", json: { message: "Internal Server Error" }
  end

  def get_my_posts
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
        .where("posts.user_id = #{params["auth_user_id"]}")
        .order("posts.created_at DESC")
        .limit(limit)
        .offset(offset)

    @user = User.find(params["auth_user_id"])

    posts = []
    @posts.each do |post|
      post_attributes = post.attributes
      post_attributes["liked_count"] = post.liked_users.count
      post_attributes["commented_count"] = post.commented_users.count
      post_attributes["already_liked"] = @user.already_liked?(post)
      posts.push(post_attributes)
    end

    render status: "200", json: posts
  rescue Exception => e
    render status: "500", json: { message: "Internal Server Error" }
  end
end
