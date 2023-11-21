class SessionsController < ApplicationController
  def create
    auth_hash = request.env["omniauth.auth"]
    name = auth_hash.dig("info", "name")
    email = auth_hash.dig("info", "email")

    found = Sheet.find_email_and_write_name(email, name)

    if found
      redirect_to root_path, notice: "ようこそ、#{name}さん！"
    else
      redirect_to root_path, alert: "メールアドレスが登録されていません"
    end
  end
end
