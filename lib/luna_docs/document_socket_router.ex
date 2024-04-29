defmodule LunaDocs.SocketRouter do
  @behaviour :cowboy_websocket

  require Logger

  # Initialization of the WebSocket connection
  def init req, _opts do
    {
      :cowboy_websocket,
      req,
      %{},
      %{
        # 1 min w/o a ping from the client and the connection is closed
        idle_timeout: 60_000,
        # Max incoming frame size of 1 MB
        max_frame_size: 1_000_000,
      }
    }
  end

  # When WebSocket connection is fully established
  def websocket_init(state) do
    Logger.info("WebSocket connection established")
    {:ok, state}
  end

  def websocket_handle({:text, "Hi"}, state) do
    {:reply, {:text, "pong"}, state}
  end

  # # Handling incoming WebSocket frames
  # def websocket_handle({:text, "ping"}, req, state) do
  #   Logger.info("Received 'ping', sending 'pong'")
  #   {:reply, {:text, "pong"}, state}
  # end

  # def websocket_handle({:text, msg}, req, state) do
  #   Logger.info("Received message: #{msg}")
  #   case msg do
  #     "ping" ->
  #       {:reply, {:text, "pong"}, state}
  #     _ ->
  #       {:ok, req, state}
  #   end
  # end

  # Handling other messages like pings, system events
  def websocket_info(any, state) do
    {:ok, any, state}
  end

  # When WebSocket connection is terminated
  def terminate(reason, _state) do
    Logger.info("WebSocket connection terminated: #{inspect(reason)}")
    :ok
  end
end
