defmodule Yoneda.ClientBot do
  require Logger

  @client Application.fetch_env!(:yoneda, :client)

  def error(user_id, text) do
    Logger.error("#{@client} to #{user_id}: #{text}")
  end

  def forward(user_id, replicated_messages_ids) do
    messages =
      replicated_messages_ids
      |> Enum.map(fn message -> "Forward: #{message}" end)
      |> Enum.join("\n")

    Logger.info("#{@client} to #{user_id}\n#{messages}")
  end
end
