class SessionsController < ApplicationController
  def create
    auth_hash = request.env["omniauth.auth"]
    name = auth_hash.dig("info", "name")
    email = auth_hash.dig("info", "email")

    redirect_to root_path, notice: "ようこそ、#{name}さん！"
  end
end
