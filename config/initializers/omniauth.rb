Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :discord,
    Rails.application.credentials.discord_app.client_id,
    Rails.application.credentials.discord_app.client_secret,
    scope: "email identify"
  )
end
