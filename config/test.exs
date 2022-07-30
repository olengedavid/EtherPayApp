import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :pay_app, PayApp.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "pay_app_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :pay_app,
  api_client: ApiClientBehaviourMock,
  etherscan_apikey: System.get_env("ETHERSCAN_APIKEY")

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pay_app, PayAppWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "mbKOqYHRone3RVu2puxSIaZ/vSAIWshISiXHi3xP/N0EPDth4QFS5Xl1EQNSx/c/",
  server: false

# In test we don't send emails.
config :pay_app, PayApp.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
