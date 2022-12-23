import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :ai_num, AiNum.Repo,
  database: "./ai_num_test.sqlite",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ai_num, AiNumWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "g4MEKrXlZz3no3t85zfezl6fN6vZpSLXQNCf9Ih97aCNZ2YHV1kmVKtS/dl4L3iN",
  server: false

# In test we don't send emails.
config :ai_num, AiNum.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
