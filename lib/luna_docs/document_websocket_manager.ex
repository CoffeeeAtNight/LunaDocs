defmodule LunaDocs.WebSocketManager do
  use GenServer
  @behaviour :cowboy_websocket
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
    # Add the PID to the state list
    {:reply, :ok, [pid | state]}
  end

  # Handle removing a connection
  def handle_call({:remove_conn, pid}, _from, state) do
    # Remove the PID from the state list
    new_state = Enum.reject(state, &(&1 == pid))
    {:reply, :ok, new_state}
  end

  @impl true
  def handle_cast({:broadcast, message}, state) do
    Enum.each(state, fn pid ->
      if Process.alive?(pid) do
        # Here we assume pid is the WebSocket connection process.
        # Ensure this is correct, and adjust accordingly if pid represents something else.
        Cowboy.WebSocket.send(pid, {:text, message})
      else
        Logger.error("Process #{inspect(pid)} is not alive.")
      end
    end)
    {:noreply, state}
  end
end
