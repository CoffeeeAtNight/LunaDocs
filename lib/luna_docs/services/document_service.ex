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

 def handle_call({:get_document_content_by_id, doc_id}, _from, state) do
    doc_id_int = String.to_integer(doc_id)
    doc = Map.get(state, doc_id_int)

    if doc == nil do
      Logger.info("Document not found for ID: #{doc_id_int}")
      {:reply, {:error, :unknown_id}, state}
    else
      doc_content = Map.get(doc, "doc_content", "")
      response = %{code: 200, data: doc_content}
      {:reply, response, state}
    end
  end

  def handle_call({:update_document_content, payload}, _from, state) do
    Logger.info("Called update document: #{inspect(payload)}")
    case Jason.decode(payload) do
      {:ok, %{"documentId" => document_id, "documentContent" => document_content}} ->
        Logger.info("Got document_id: #{document_id}, document_content: #{document_content}")

        document_id_int =
        case is_integer(document_id) do
          true -> document_id
          false -> String.to_integer(document_id)
        end

        new_state = Map.update(state, document_id_int, %{"doc_content" => document_content, "doc_name" => ""}, fn old -> Map.put(old, "doc_content", document_content) end)
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
