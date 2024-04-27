defmodule Lunadocs.Repo do
  use Ecto.Repo,
    otp_app: :lunadocs,
    adapter: Ecto.Adapters.SQLite3
end
