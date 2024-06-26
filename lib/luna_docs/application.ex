defmodule LunaDocs.Application do
  use Application
  use PlugSocket
  require Logger

  def start(_type, _args) do
    children = [
      LunaDocs.DocumentService,
      {Plug.Cowboy,
       scheme: :http,
       plug: LunaDocs.DocumentEndpoints,
       options: [
         port: 8000,
         dispatch: [
          {:_, [
            {:_, Plug.Cowboy.Handler, {LunaDocs.DocumentEndpoints, []}},
          ]}
        ]
       ]
      }
    ]

    Logger.info("Application and Supervisors starting...")
    opts = [strategy: :one_for_one, name: LunarDocs.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
