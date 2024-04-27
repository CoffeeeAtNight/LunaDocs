defmodule LunaDocs.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      #LunaDocs.DocumentWorker,
      {Plug.Cowboy, scheme: :http, plug: LunaDocs.DocumentWorkerPlug, options: [port: 8000]}
    ]

    opts = [strategy: :one_for_one, name: LunarDocs.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
