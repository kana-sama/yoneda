defmodule Yoneda.Dialogue do
  use GenServer

  @lifetime 100

  def start_link(user_id) do
    name = {:via, Registry, {Yoneda.Dialogue.Registry, user_id}}
    GenServer.start_link(__MODULE__, user_id, name: name)
  end

  def message(user_id, message) do
    try do
      GenServer.call(get(user_id), {:message, message})
    catch
      :exit, _ ->
        :timer.sleep(div(@lifetime, 2))
        message(user_id, message)
    end
  end

  # Priv

  defmodule State do
    defstruct [:user_id, replicators: Map.new(), messages: []]
  end

  defp start(user_id) do
    {:ok, dialogue} = Yoneda.Dialogue.start_link(user_id)
    dialogue
  end

  defp get(user_id) do
    case Registry.lookup(Yoneda.Dialogue.Registry, user_id) do
      [{dialogue, _}] ->
        if Process.alive?(dialogue) do
          dialogue
        else
          start(user_id)
        end

      [] ->
        start(user_id)
    end
  end

  # Impl

  @impl GenServer
  def init(user_id) do
    {:ok, %State{user_id: user_id}, @lifetime}
  end

  @impl GenServer
  def handle_call({:message, message}, _, state) do
    case Map.fetch(state.replicators, message.author_id) do
      {:ok, replicator} ->
        {:reply, :ok, state, {:continue, {:replicate_message, replicator, message}}}

      :error ->
        case Yoneda.ReplicatorBot.request_replicator(Map.values(state.replicators)) do
          :no_replicators ->
            {:stop, {:shutdown, :no_replicators}, state}

          replicator ->
            state = update_in(state.replicators, &Map.put(&1, message.author_id, replicator))
            {:reply, :ok, state, {:continue, {:replicate_message, replicator, message}}}
        end
    end
  end

  @impl GenServer
  def handle_continue({:replicate_message, replicator, message}, state) do
    replicated_message_id = Yoneda.ReplicatorBot.send(replicator, message.text)
    state = update_in(state.messages, &(&1 ++ [replicated_message_id]))
    {:noreply, state, @lifetime}
  end

  @impl GenServer
  def handle_info(:timeout, state) do
    {:stop, :normal, state}
  end

  @impl GenServer
  def terminate(:normal, state) do
    Yoneda.ClientBot.forward(state.user_id, state.messages)
  end

  @impl GenServer
  def terminate({:shutdown, :no_replicators}, state) do
    Yoneda.ClientBot.error(state.user_id, "To much actors of dialogue")
  end
end
