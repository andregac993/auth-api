Devise.setup do |config|
  config.mailer_sender = "please-change-me-at-config-initializers-devise@example.com"

  require "devise/orm/active_record"

  config.case_insensitive_keys = [ :email ]
  config.strip_whitespace_keys = [ :email ]

  config.skip_session_storage = [ :http_auth ]

  config.clean_up_csrf_token_on_authentication = true

  config.stretches = Rails.env.test? ? 1 : 12

  config.password_length = 6..128

  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  jwt_secret = ENV.fetch("DEVISE_JWT_SECRET_KEY", nil) ||
               Rails.application.credentials.devise_jwt_secret_key ||
               "jwt_fallback_for_tests"

  config.jwt do |jwt|
    jwt.secret = jwt_secret
    jwt.dispatch_requests = [
      [ "POST", %r{^/api/login$} ],
      [ "POST", %r{^/api/signup$} ]
    ]
    jwt.revocation_requests = [
      [ "DELETE", %r{^/api/logout$} ]
    ]
    jwt.expiration_time = 1.day.to_i
  end

  config.navigational_formats = [ "*/*", :html, :json ]

  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other
end
