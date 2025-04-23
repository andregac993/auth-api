# frozen_string_literal: true

# Assuming you have not yet modified this file, each configuration option below
# is set to its default value. Note that some are commented out while others
# are not: uncommented lines are intended to protect your configuration from
# breaking changes in upgrades (i.e., in the event that future versions of
# Devise change the default values for those options).
#
# Use this hook to configure devise mailer, warden hooks and so forth.
# Many of these configuration options can be set straight in your model.
Devise.setup do |config|
  # The secret key used by Devise. Devise uses this key to generate
  # random tokens. Changing this key will render invalid all existing
  # confirmation, reset password and unlock tokens in the database.
  # By default, Devise uses Rails.application.secret_key_base.
  # If you prefer, you can set your own:
  # config.secret_key = 'your_own_secret_key'

  # ==> Mailer Configuration
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'

  # Load and configure the ORM. Supports :active_record (default).
  require 'devise/orm/active_record'

  # ==> Configuration for any authentication mechanism
  # Configure which parameters are case-insensitive.
  config.case_insensitive_keys = [:email]
  # Configure which parameters should have whitespace stripped.
  config.strip_whitespace_keys = [:email]

  # Skip session storage for these strategies.
  config.skip_session_storage = [:http_auth]

  # Tell if authentication through request.params is enabled.
  # True by default.
  # config.params_authenticatable = true

  # By default Devise will clean up the CSRF token on authentication.
  config.clean_up_csrf_token_on_authentication = true

  # ==> Configuration for :database_authenticatable
  # For bcrypt, this is the cost for hashing the password.
  config.stretches = Rails.env.test? ? 1 : 12

  # Range for password length.
  config.password_length = 6..128

  # Regex for validating email formats.
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # ==> Configuration for :confirmable, :lockable, etc.
  # config.allow_unconfirmed_access_for = 2.days
  # config.maximum_attempts = 20
  # config.unlock_in = 1.hour

  # ==> JWT configuration
  #
  # Use devise-jwt to dispatch and revoke tokens.
  config.jwt do |jwt|
    # Load your secret key from ENV (ensure .env / Docker env_file is set)
    jwt.secret = ENV.fetch('DEVISE_JWT_SECRET_KEY')

    # When to dispatch a new JWT to the client
    jwt.dispatch_requests = [
      ['POST', %r{^/api/login$}],
      ['POST', %r{^/api/signup$}]
    ]

    # When to revoke the JWT (if you support logout)
    jwt.revocation_requests = [
      ['DELETE', %r{^/api/logout$}]
    ]

    # How long until the token expires (in seconds)
    jwt.expiration_time = 24 * 3600  # 1 day
  end

  # ==> Navigation configuration
  # Formats like :html redirect on failure, but :json should return 401.
  config.navigational_formats = ['*/*', :html, :json]

  # ==> Warden configuration
  # config.warden do |manager|
  #   manager.failure_app = CustomFailureApp
  # end

  # ==> Mountable engine configurations
  # config.router_name = :my_engine
  # config.omniauth_path_prefix = '/my_engine/users/auth'

  # ==> Hotwire/Turbo configuration
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other
end
