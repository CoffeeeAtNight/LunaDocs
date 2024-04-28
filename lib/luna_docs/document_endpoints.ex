defmodule LunaDocs.DocumentEndpoints do
  use Plug.Router
  alias LunaDocs.DocumentService
  require Logger

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

  get "/ws" do

  end

  # get "/" do
  #   response = GenServer.call(:document_service, {:create_document, "Test Document"})
  #   response |> handle_response(conn)
  # end

  get "/favicon.ico" do
    conn
    |> send_resp(204, "")
  end

  match _ do
    conn
    |> send_resp(404, "Not Found")
  end

  # def call(conn, _opts) do
  #   response = GenServer.call(:document_service, {:create_document, "Test Document"})
  #   doc_name = create_document_handle(response)
  #   send_resp(put_resp_content_type(conn, "text/plain"), 200, doc_name)
  # end

  # def create_document_handle(response) do
  #     case response do
  #       {:ok, state} when is_map(state) ->
  #         IO.puts("Document created successfully, state is now: #{inspect(state)}")
  #         "Document created"
  #       {:error, reason} ->
  #         IO.puts("Failed to create document: #{inspect(reason)}")
  #         "error"
  #       _ ->
  #         IO.puts("No matching case found...")
  #         "no case"
  #       end
  # end

  defp handle_response(response, conn) do
    case response do
      %{code: code, message: message, data: data} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(code, Jason.encode!(%{message: message, data: data}))

      _ ->
        Logger.error("Failed to handle request for path: #{conn.request_path}")
        send_resp(conn, 500, "Internal server error")
    end
  end
end
