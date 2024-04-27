defmodule LunaDocs.DocumentWorker do
  use GenServer

  def init(init_state) do
    {:ok, init_state}
  end

  def handle_call({:create_document, doc_id, doc_name}, _from, state) do
    new_state = Map.put(state, doc_id, doc_name)
    {:reply, :ok, new_state}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end
end
