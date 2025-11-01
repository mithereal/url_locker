defmodule UrlLocker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      UrlLockerWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:url_locker, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: UrlLocker.PubSub},
      # Start a worker by calling: UrlLocker.Worker.start_link(arg)
      # {UrlLocker.Worker, arg},
      # Start to serve requests, typically the last entry
      UrlLockerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UrlLocker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    UrlLockerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
