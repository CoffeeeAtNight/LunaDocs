defmodule LunaDocs.DocumentEndpoints do
  use Plug.Router
  use PlugSocket
  require Logger

  socket "/ws", LunaDocs.SocketRouter

  plug Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason

  plug Plug.Static,
    at: "/",
    from: :luna_docs,
    gzip: false


  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, File.read!("priv/static/index.html"))
  end


 post "/api/create/document" do
    case conn.body_params do
      %{"documentName" => docName} ->
        Logger.info("Called endpoint to create doc!!")
        response = GenServer.call(:document_service, {:create_document, docName})
        Logger.info("Now calling handle_response with: #{inspect(response)}")
        handle_response(response, conn)

      _ ->
        conn
        |> send_resp(422, "Document name is missing")
        |> halt()
    end
  end

  get "/api/documents" do
    Logger.info("Called endpoint to create doc!!")
    response = GenServer.call(:document_service, {:get_documents})
    Logger.info("Now calling handle_response with: #{inspect(response)}")
    handle_response(response, conn)
  end

  get "/favicon.ico" do
    conn
    |> send_resp(204, "")
  end

  match _ do
    conn
    |> send_resp(404, "Not Found")
  end

  defp handle_response(response, conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(response))
  end
end
