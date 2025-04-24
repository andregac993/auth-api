module Api
  class SessionsController < ApplicationController
    def create
      user = User.find_for_database_authentication(email: session_params[:email])

      if user&.valid_password?(session_params[:password])
        token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
        render json: {
          user_id: user.id,
          token: token
        }, status: :ok
      else
        render json: {
          error: I18n.t("devise.failure.invalid", authentication_keys: "email")
        }, status: :unauthorized
      end
    end

    private

    def session_params
      params.require(:user).permit(:email, :password)
    end
  end
end
