defmodule LunaDocs.DocumentWorkerPlug do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    IO.puts("HTTP server starting...")
    send_resp(put_resp_content_type(conn, "text/plain"), 200, "LunaDocs!")
  end
end
