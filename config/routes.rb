Rails.application.routes.draw do
  get "/up" => "rails/health#show", as: :rails_health_check

  get "/auth/discord/callback", to: "sessions#create"

  root "welcome#index"
end
