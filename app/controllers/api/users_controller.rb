class Api::UsersController < ApplicationController
    before_action :authenticate_api_user!

    def get_users
        @user = User.all
        return render status: "400", json: "User not found" if !@user

        return render status: "200", json: @user
    end
end
