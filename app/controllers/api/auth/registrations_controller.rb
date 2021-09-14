class Api::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  def create
    @user = User.new(registration_params)
    unless @user.valid?
      errors = @user.errors
      return render status: 400, json: { status: 400, message: errors }
    end
    @user.create_token
    @user.save!
    return render status: 200, json: { status: 200, message: "Success" }
  end

  private

  def registration_params
    params.permit(:username, :email, :password)
  end
end
