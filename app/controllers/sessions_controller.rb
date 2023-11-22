class SessionsController < ApplicationController
  def create
    auth_hash = request.env["omniauth.auth"]
    name = auth_hash.dig("info", "name")
    email = auth_hash.dig("info", "email")
    user_id = auth_hash.dig("uid")
    user_token = auth_hash.dig("credentials", "token")

    found = Sheet.find_email_and_write_name(email, name)

    if found
      discord = Discord.new(ENV["DISCORD_BOT_TOKEN"])
      server = discord.servers.find { |s| s["name"] == ENV["DISCORD_SERVER_NAME"] }
      role = discord.roles(server["id"]).find { |r| r["name"] == ENV["DISCORD_ROLE_NAME"] }
      discord.invite(server_id: server["id"], user_id: user_id, user_token: user_token)
      discord.add_role(server_id: server["id"], user_id: user_id, role_id: role["id"])

      redirect_to root_path, notice: "ようこそ、#{name}さん！"
    else
      redirect_to root_path, alert: "メールアドレスが登録されていません"
    end
  end
end
