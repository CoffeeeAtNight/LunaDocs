defmodule LunaDocs.SocketRouter do
  @behaviour :cowboy_websocket
  require Logger

  def init(req, _opts) do
    {:cowboy_websocket, req, %{sender_pid: self()}, %{idle_timeout: 60_000, max_frame_size: 1_000_000}}
  end

 def websocket_init(state) do
    # Retrieve all documents
    response = GenServer.call(:document_service, {:get_documents})

    # Extract the first document's ID
    document_id = extract_document_id(response.data)

    # Check for nil and handle if necessary
    if is_nil(document_id) do
      Logger.error("No documents available to initialize WebSocket.")
      {:error, :no_documents}
    else
      # Update state with the document ID
      updated_state = Map.put(state, :document_id, document_id)

      # Register this WebSocket connection with the document ID in the Registry
      Registry.register(LunaDocs.Registry, "doc:#{document_id}", [])

      Logger.info("WebSocket initialized for document ID: #{document_id}")
      {:ok, updated_state}
    end
  end

  defp extract_document_id(documents) do
    # Get the first ":id" from the list
    documents
    |> Map.keys()
    |> Enum.at(0, nil)
  end

   def websocket_handle({:text, json_string}, state) do
    Logger.info("Received message: #{json_string}")
    case Jason.decode(json_string) do
      {:ok, data} when is_map(data) ->
        Logger.info("Decoded JSON: #{Jason.encode!(data)}")
        # Pass the document_id from state and the data to be broadcasted
        Logger.info("Document ID: #{state.document_id}, Data: #{inspect(data)}")
        save_doc(Jason.encode!(data))
        # broadcast_message(state.document_id, data)
        {:reply, {:text, Jason.encode!(%{response: "Message broadcasted"})}, state}
      {:error, _error} ->
        Logger.error("Failed to decode JSON: #{json_string}")
        {:reply, {:text, Jason.encode!(%{error: "Invalid JSON format"})}, state}
      _ ->
        Logger.error("Unexpected message format")
        {:reply, {:text, Jason.encode!(%{error: "Unexpected message format"})}, state}
    end
  end

  # def websocket_handle({:text, json_string}, state) do
  #   Logger.info("Received message: #{json_string}")
  #   case Jason.decode(json_string) do
  #     {:ok, data} when is_map(data) ->
  #       Logger.info("Decoded JSON: #{Jason.encode!(data)}")
  #       # Directly echo back the received message for testing
  #       {:reply, {:text, json_string}, state}
  #     {:error, _error} ->
  #       {:reply, {:text, Jason.encode!(%{error: "Invalid JSON format"})}, state}
  #     _ ->
  #       {:reply, {:text, Jason.encode!(%{error: "Unexpected message format"})}, state}
  #   end
  # end


  defp save_doc(doc_content) do
    response = GenServer.call(:document_service, {:update_document_content, doc_content})
    Logger.info("Response is: #{inspect(response)}")
  end

  defp broadcast_message(document_id, message) do
    # Assume message is already in proper format or encode it here
    Logger.info("Broadcasting message: #{inspect(message)} for id #{document_id}")
    encoded_message = Jason.encode!(message)
    subscribers = Registry.lookup(LunaDocs.Registry, "doc:#{document_id}")
    Logger.info("Subscribers: #{inspect(subscribers)}")
    Enum.each(subscribers, fn {pid, _} ->
      send(pid, {:text, encoded_message})
    end)
  end

  def websocket_info(any, state) do
    {:ok, any, state}
  end

  def terminate(_reason, state) do
    Registry.unregister(LunaDocs.Registry, "doc:#{state.document_id}")
    :ok
  end

  # defp handle_manager_communication(operation, pid) do
  #   try do
  #     GenServer.call(:websocket_manager, {operation, pid})
  #   rescue
  #     exception ->
  #       Logger.error("Failed to communicate with WebSocket Manager: #{inspect(exception)}")
  #   end
  # end
end
