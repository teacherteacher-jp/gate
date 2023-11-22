class Discord
  BASE_URL = "https://discord.com"
  BASE_PATH = "/api/v10"

  def initialize(bot_token)
    @connection = Faraday.new(
      url: BASE_URL,
      headers: { "Authorization" => "Bot #{bot_token}" }
    )
  end

  def servers
    JSON.parse(get("/users/@me/guilds").body)
  end

  def get(path)
    @connection.get(BASE_PATH + path)
  end
end
