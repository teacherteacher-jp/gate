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
      channels = discord.channels(server["id"])
      channel = channels.find { |c| c["name"] == ENV["DISCORD_CHANNEL_NAME"] }
      result = discord.invite(server_id: server["id"], user_id: user_id, user_token: user_token)

      if result.status == 201
        discord.add_role(server_id: server["id"], user_id: user_id, role_id: role["id"])
        discord.post_message(channel_id: channel["id"], content: "「#{name}」さんがやってきました、ようこそ！")
      end

      redirect_to root_path, notice: "こんにちは、#{name}さん！招待しましたのでDiscordアプリをご確認ください"
    else
      redirect_to root_path, alert: "Discordの登録メールアドレスが、スポンサーのメールアドレス一覧に見つかりませんでした。お手数ですがmail@example.comまで「スポンサー申請時の氏名」「Discordの登録メールアドレス」をご連絡ください。"
    end
  end
end
