module Api
  class RegistrationsController < ApplicationController
    rescue_from ActionController::ParameterMissing do |exception|
      render json: { error: exception.message }, status: :bad_request
    end

    def create
      user = User.new(registration_params)

      if user.save
        render json: {
          user: {
            id: user.id,
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
      params.require(:user).permit(
        :name,
        :email,
        :password,
        :password_confirmation,
        address_attributes: [
          :zip_code,
          :city,
          :state
        ]
      )
    end
  end
end
