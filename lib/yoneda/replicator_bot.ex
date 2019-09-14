defmodule Yoneda.ReplicatorBot do
  use GenServer

  @replicatory Application.fetch_env!(:yoneda, :replicatory)
  @replicators Application.fetch_env!(:yoneda, :replicators)

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def request_replicator(ignore) do
    try do
      MapSet.difference(MapSet.new(@replicators), MapSet.new(ignore))
      |> Enum.random()
    rescue
      Enum.EmptyError ->
        :no_replicators
    end
  end

  def replicate(bot_id, message) do
    GenServer.call(__MODULE__, {:replicate, bot_id, message})
  end

  @impl GenServer
  def init([]) do
    {:ok, []}
  end

  @impl GenServer
  def handle_call({:replicate, bot_id, message}, _, []) do
    case Yoneda.TelegramBotAPI.send_message(bot_id, @replicatory, message) do
      %{"ok" => true, "result" => %{"message_id" => message_id}} ->
        {:reply, message_id, []}

      _ ->
        {:stop, :normal, []}
    end
  end
end
