defmodule LunaDocs.SocketRouter do
  @behaviour :cowboy_websocket
  require Logger

  def init(req, _opts) do
    {:cowboy_websocket, req, %{sender_pid: self()}, %{idle_timeout: 60_000, max_frame_size: 1_000_000}}
  end

  def websocket_init(state) do
    Logger.info("WebSocket connection established")
    handle_manager_communication(:add_conn, self())
    {:ok, state}
  end

  def websocket_handle({:text, json_string}, state) do
    Logger.info("Received message: #{json_string}")
    case Jason.decode(json_string) do
      {:ok, data} when is_map(data) ->
        Logger.info("Decoded JSON: #{Jason.encode!(data)}")
        broadcast_message(data, state.sender_pid)
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


  defp broadcast_message(message, sender_pid) do
    encoded_message = Jason.encode!(message)

    case GenServer.call(:websocket_manager, :get_connections) do
      {:ok, connection_pids} ->
        Enum.each(connection_pids, fn pid ->
          if pid != sender_pid do
            try do
              send(pid, {:text, encoded_message})
            rescue
              exception ->
                Logger.error("Failed to send message to #{inspect(pid)}: #{exception.message}")
            else
              _ ->
                Logger.info("Successfully broadcasted message to #{inspect(pid)}")
            end
          end
        end)
      error ->
        Logger.error("Error retrieving connections: #{inspect(error)}")
    end
  end

  def websocket_info(any, state) do
    {:ok, any, state}
  end

  def terminate(reason, state) do
    Logger.info("WebSocket connection terminated: #{inspect(reason)}")
    handle_manager_communication(:remove_conn, state.sender_pid)
    :ok
  end

  defp handle_manager_communication(operation, pid) do
    try do
      GenServer.call(:websocket_manager, {operation, pid})
    rescue
      exception ->
        Logger.error("Failed to communicate with WebSocket Manager: #{inspect(exception)}")
    end
  end
end
