defmodule PayApp.Repo do
  use Ecto.Repo,
    otp_app: :pay_app,
    adapter: Ecto.Adapters.Postgres
end
