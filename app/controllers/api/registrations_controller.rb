module Api
  class RegistrationsController < ApplicationController
    def create
      user = User.new(registration_params)

      if user.save
        render json: {
          user: {
            id: user.id,
            name: user.name,
            email: user.email
          },
          message: I18n.t("devise.registrations.signed_up")
        }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def registration_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  end
end
