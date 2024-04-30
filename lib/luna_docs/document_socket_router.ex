defmodule LunaDocs.SocketRouter do
  @behaviour :cowboy_websocket
  require Logger

  def init(req, _opts) do
    {:cowboy_websocket, req, %{}, %{idle_timeout: 60_000, max_frame_size: 1_000_000}}
  end

  def websocket_init(state) do
    Logger.info("WebSocket connection established")
    GenServer.call(:websocket_manager, {:add_conn, self()})
    {:ok, state}
  end

  def websocket_handle({:text, message}, state) do
    GenServer.call(:document_service, {:update_document_content, message})
    GenServer.cast(:websocket_manager, {:broadcast, message})
    {:reply, {:text, message}, state}
  end

  def websocket_info(any, state) do
    {:ok, any, state}
  end

  def terminate(reason, _state) do
    Logger.info("WebSocket connection terminated: #{inspect(reason)}")
    # Unregister the connection
    GenServer.call(LunaDocs.WebSocketManager, {:remove_conn, self()})
    :ok
  end
end
