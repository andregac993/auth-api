Rails.application.routes.draw do
  mount Rswag::Api::Engine => "/api-docs"
  mount Rswag::Ui::Engine  => "/api-docs"

  namespace :api do
    post   "signup", to: "registrations#create"
    get    "status", to: "status#index"
  end

  root to: ->(_) { [200, {"Content-Type" => "text/plain"}, ["API is running 🚀"]] }
end
