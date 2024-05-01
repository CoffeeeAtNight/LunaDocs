defmodule LunaDocs.WebSocketManager do
  use GenServer
  require Logger

  # Start the GenServer with a unique name
  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: :websocket_manager)
  end

  # Initialize with an empty list to hold connection PIDs
  @impl true
  def init(_args) do
    {:ok, []}
  end

  # Handle adding a connection
  @impl true
  def handle_call({:add_conn, pid}, _from, state) do
    Logger.info("Adding connection: #{inspect(pid)}")
    {:reply, :ok, [pid | state]}
  end

  # Handle removing a connection
  def handle_call({:remove_conn, pid}, _from, state) do
    new_state = Enum.reject(state, &(&1 == pid))
    {:reply, :ok, new_state}
  end

  def handle_call(:get_connections, _from, state) do
    {:reply, {:ok, state}, state}
  end

  @impl true
  def handle_cast({:broadcast, encoded_message}, state) do
    Enum.each(state, fn pid ->
      Logger.info("Sending message to: #{inspect(pid)} with: #{encoded_message}")
      send(pid, {:text, encoded_message})
    end)
    {:noreply, state}
  end
end
