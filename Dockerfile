# Dockerfile
FROM ruby:3.3.0

# Define environment variables
ENV RAILS_ENV=development \
    BUNDLER_VERSION=2.4.22 \
    LANG=C.UTF-8

# Set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    postgresql-client \
    yarn \
    && rm -rf /var/lib/apt/lists/*

# Install bundler
RUN gem install bundler:$BUNDLER_VERSION

# Copy Gemfiles first and install gems (to leverage Docker cache)
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy remaining files
COPY . .

# Expose default Rails port
EXPOSE 3000

# Entrypoint script to wait for DB and run commands
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]

# Default command
CMD ["rails", "server", "-b", "0.0.0.0"]
