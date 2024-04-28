defmodule LunaDocs.DocumentService do
  use GenServer

  require Logger

  @impl true
  def init(_args) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:create_document, doc_name}, _from, state) do
   next_id = get_next_id(state)
    Logger.info("Called :create_document with id: #{next_id}, doc_name: #{doc_name}")
    new_state = Map.update(state, next_id, %{doc_content: "", doc_name: doc_name}, fn _old_val ->
      %{doc_content: "", doc_name: doc_name}
    end)

    response = %{code: 200, message: "Document created successfully", data: new_state}
    {:reply, response, new_state}
  end

  def get_next_id(state) do
    state
    |> Map.keys()
    |> Enum.reduce(0, &max/2)
    |> Kernel.+(1)
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: :document_service)
  end
end
