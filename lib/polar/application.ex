defmodule Polar.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PolarWeb.Telemetry,
      Polar.Repo,
      {DNSCluster, query: Application.get_env(:polar, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Polar.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Polar.Finch},
      # Start a worker by calling: Polar.Worker.start_link(arg)
      # {Polar.Worker, arg},
      # Start to serve requests, typically the last entry
      PolarWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Polar.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PolarWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
