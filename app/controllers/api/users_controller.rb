class Api::UsersController < ApplicationController
  before_action :authenticate_api_user!

  def get_users
    @user = User.all
    return render status: "400", json: "User not found" if !@user

    return render status: "200", json: @user
  rescue Exception => e
    render status: "500", json: { message: "Internal Server Error" }
  end

  def get_user
    @user = User.find_by(uid: params["uid"])
    return render status: "400", json: "User not found" if !@user

    return render status: "200", json: @user
  rescue Exception => e
    render status: "500", json: { message: "Internal Server Error" }
  end
end
