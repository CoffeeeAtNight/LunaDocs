defmodule LunaDocs.Application do
  use Application

  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      LunaDocs.DocumentService,
      {Plug.Cowboy, scheme: :http, plug: LunaDocs.DocumentEndpoints, options: [port: 8000]}
    ]

    Logger.info "Application and Supervisors starting ..."

    opts = [strategy: :one_for_one, name: LunarDocs.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
