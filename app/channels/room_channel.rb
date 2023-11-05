class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    message =
      Message.create(
        user_id: current_user.id,
        room_id: 1,
        content: data["body"]
      )
    p message
    ActionCable.server.broadcast(
      "room_channel",
      { sender: current_user.username, body: message }
    )
  rescue Exception => e
    p e
  end
end
