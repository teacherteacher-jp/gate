class InvitesNotifier
  def self.notify
      discord = Discord.new(ENV["DISCORD_BOT_TOKEN"])
      servers = discord.servers
      server = servers.find { |s| s["name"] == ENV["DISCORD_SERVER_NAME"] }
      invites = discord.invites(server["id"]).sort_by { _1["created_at"] }
      channels = discord.channels(server["id"])
      channel = channels.find { |c| c["name"] == ENV["DISCORD_SYSTEM_CHANNEL_NAME"] }

      invites.each_slice(50).each do |sub_invites|
        message =
          "```" +
          ["created", "expires", "code", "uses", "inviter"].map { _1.ljust(10) }.join("\t") + "\n" +
          sub_invites.map { |inv|
            expires_at = inv.dig("expires_at")
            [
              inv.dig("created_at").first(10),
              expires_at ? expires_at.first(10) : "----------",
              inv.dig("code"),
              inv.dig("uses").to_s,
              inv.dig("inviter", "global_name"),
            ].map { _1.ljust(10) }.join("\t")
          }.join("\n") +
          "```"

        discord.post_message(channel_id: channel["id"], content: message)
        sleep 2
      end
   end
end
