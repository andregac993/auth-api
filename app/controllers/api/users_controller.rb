module Api
  class UsersController < ApplicationController
    before_action :authenticate_user!

    def me
      render json: {
        user: {
          id: current_user.id,
          name: current_user.name,
          email: current_user.email,
          address: {
            zip_code: current_user.address&.zip_code,
            city: current_user.address&.city,
            state: current_user.address&.state
          }
        }
      }, status: :ok
    end
  end
end
