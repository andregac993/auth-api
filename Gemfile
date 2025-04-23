source "https://rubygems.org"

gem "rails", "~> 7.2.2", ">= 7.2.2.1"
gem "pg", "~> 1.1"

gem "puma", ">= 5.0"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

gem "devise"
gem "devise-jwt"
gem "dotenv-rails"

group :development do
  gem "overcommit"
end

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "rspec-rails", "~> 7.0.0"
  gem "rswag-ui"
  gem "rswag-api"
  gem "rubocop-performance"
  gem "rubocop-rails"
  gem "rubocop-rspec"
end
