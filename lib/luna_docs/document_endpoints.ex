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


 post "/api/document" do
    case conn.body_params do
      %{"documentName" => docName} ->
        Logger.info("Called endpoint to create doc!")
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
    Logger.info("GET /docs called")
    handle_response(response, conn)
  end

  get "/api/document/:id" do
    response = GenServer.call(:document_service, {:get_document_content_by_id, id})
    Logger.info("GET /doc/id called")
    handle_response(response, conn)
  end

  put "/api/document/:id" do
    case conn.body_params do
      %{"documentId" => docId, "documentContent" => _docContent} ->
        Logger.info("Called endpoint to update doc with id: #{inspect(docId)}")
        response = GenServer.call(:document_service, {:update_document_content, Jason.encode!(conn.body_params)})
        Logger.info("Now calling handle_response with: #{inspect(response)}")
        handle_response(response, conn)

      _ ->
        conn
        |> send_resp(400, "Missing values in body")
        |> halt()
    end
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
