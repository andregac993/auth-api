class ApplicationController < ActionController::API
  rescue_from ActionDispatch::Http::Parameters::ParseError, with: :handle_parse_error

  private

  def handle_parse_error(exception)
    render json: {
      error: "Invalid JSON format or malformed request payload.",
      message: exception.message
    }, status: :bad_request
  end

  def authenticate_user!
    token = request.headers["Authorization"]&.split(" ")&.last
    return render_unauthorized("Missing token") unless token

    begin
      payload = Warden::JWTAuth::TokenDecoder.new.call(token)
      @current_user = User.find(payload["sub"])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render_unauthorized("Invalid token")
    end
  end

  def render_unauthorized(message = "Unauthorized")
    render json: { error: message }, status: :unauthorized
  end

  def current_user
    @current_user
  end
end
