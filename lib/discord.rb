class Discord
  BASE_URL = "https://discord.com"
  BASE_PATH = "/api/v10"

  def initialize(bot_token)
    @connection = Faraday.new(
      url: BASE_URL,
      headers: {
        "Authorization" => "Bot #{bot_token}",
        "Content-Type" => "application/json"
      }
    )
  end

  def servers
    JSON.parse(get("/users/@me/guilds").body)
  end

  def roles(server_id)
    JSON.parse(get("/guilds/#{server_id}/roles").body)
  end

  def channels(server_id)
    JSON.parse(get("/guilds/#{server_id}/channels").body)
  end

  def invites(server_id)
    JSON.parse(get("/guilds/#{server_id}/invites").body)
  end

  def post_message(channel_id:, content:)
    @connection.post(BASE_PATH + "/channels/#{channel_id}/messages") do |request|
      request.body = { content: content }.to_json
    end
  end

  def invite(server_id:, user_id:, user_token:)
    @connection.put(BASE_PATH + "/guilds/#{server_id}/members/#{user_id}") do |request|
      request.body = { access_token: user_token }.to_json
    end
  end

  def add_role(server_id:, user_id:, role_id:)
    @connection.put(BASE_PATH + "/guilds/#{server_id}/members/#{user_id}/roles/#{role_id}")
  end

  def get(path)
    @connection.get(BASE_PATH + path)
  end
end
