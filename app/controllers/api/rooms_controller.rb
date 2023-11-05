class Api::RoomsController < ApplicationController
  before_action :authenticate_api_user!

  def get_messages
    @messages =
      Message
        .select(
          "id,
        content,
        user_id,
        room_id"
        )
        .order("created_at DESC")

    render status: "200", json: @messages
  rescue Exception => e
    render status: "500", json: { message: "Internal Server Error" }
  end
end
