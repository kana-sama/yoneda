defmodule Yoneda.ClientBot do
  use GenServer
  require Logger

  @client Application.fetch_env!(:yoneda, :client)

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def error(user_id, text) do
    GenServer.cast(__MODULE__, {:error, user_id, text})
  end

  def forward(user_id, replicated_messages_ids) do
    GenServer.cast(__MODULE__, {:forward, user_id, replicated_messages_ids})
  end

  @impl GenServer
  def init([]) do
    Yoneda.Dialogue.message(1, %Yoneda.Message{author_id: "a", text: "1"})
    :timer.sleep(50)
    Yoneda.Dialogue.message(1, %Yoneda.Message{author_id: "b", text: "2"})
    :timer.sleep(50)
    Yoneda.Dialogue.message(1, %Yoneda.Message{author_id: "c", text: "3"})
    :timer.sleep(50)
    Yoneda.Dialogue.message(1, %Yoneda.Message{author_id: "d", text: "4"})
    :timer.sleep(300)
    Yoneda.Dialogue.message(1, %Yoneda.Message{author_id: "e", text: "5"})

    {:ok, []}
  end

  @impl GenServer
  def handle_cast({:error, user_id, text}, []) do
    Logger.error("[#{@client} -> #{user_id}] #{text}")

    {:noreply, []}
  end

  @impl GenServer
  def handle_cast({:forward, user_id, replicated_messages_ids}, []) do
    messages =
      replicated_messages_ids
      |> Enum.map(&"Forward: #{&1}")
      |> Enum.join("\n")

    Logger.info("[#{@client} -> #{user_id}] \n#{messages}")

    {:noreply, []}
  end
end
