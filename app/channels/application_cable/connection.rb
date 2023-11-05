module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    # def disconnect
    #   # Any cleanup work needed when the cable connection is cut.
    # end

    private

    def find_verified_user
      # cookies.signed[:user_id] = User.first.id
      # verified_user = User.all.first
      # if verified_user
      #   # do something
      # else
      #   reject_unauthorized_connection
      # end
      User.all.first
    end
  end
end
