import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ai_num, AiNumWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "wrsb4jh9FCF/RWQnkxaPgXvtTo838/mL42tNg9TD1MZrePLGksqZT6I8XBXrBvKy",
  server: false

# In test we don't send emails.
config :ai_num, AiNum.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
