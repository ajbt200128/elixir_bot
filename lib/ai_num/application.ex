defmodule AiNum.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      AiNum.Repo,
      # Start the Telemetry supervisor
      AiNumWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: AiNum.PubSub},
      # Start the Endpoint (http/https)
      AiNumWeb.Endpoint
      # Start a worker by calling: AiNum.Worker.start_link(arg)
      # {AiNum.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AiNum.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AiNumWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
