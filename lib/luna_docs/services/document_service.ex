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

    response = %{code: 200, data: new_state}
    {:reply, response, new_state}
  end

  def handle_call({:get_documents}, _from, state) do
    Logger.info("Called :get_documents")
    response = %{code: 200, data: state}
    {:reply, response, state}
  end

  def handle_call({:update_document_content, payload}, _from, state) do
    Logger.info("Called update document: #{inspect(payload)}")
    case Jason.decode(payload) do
      {:ok, %{"documentId" => document_id, "documentContent" => document_content}} ->
        document_id = String.to_integer(document_id)
        new_state = Map.update(state, document_id, %{"doc_content" => document_content, "doc_name" => ""}, fn old -> Map.put(old, "doc_content", document_content) end)
        {:reply, :ok, new_state}

      _error ->
        {:reply, {:error, :invalid_payload}, state}
    end
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
