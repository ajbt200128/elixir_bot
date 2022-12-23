# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :ai_num, AiNumWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: AiNumWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: AiNum.PubSub,
  live_view: [signing_salt: "JnTPv7wX"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :ai_num, AiNum.Mailer, adapter: Swoosh.Adapters.Local

config :ai_num,
  ecto_repos: [AiNum.Repo]
# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ex_twilio,
  account_sid: {:system, "TWILIO_ACCOUNT_SID"},
  auth_token: {:system, "TWILIO_AUTH_TOKEN"}

config :openai,
  api_key: {:system, "OPENAI_API_KEY"},
  http_options: [recv_timeout: 30_000]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
