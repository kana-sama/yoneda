defmodule Yoneda.ClientBot do
  require Logger

  def error(user_id, text) do
    Logger.error("to #{user_id}: #{text}")
  end

  def forward(user_id, replicated_messages_ids) do
    messages = replicated_messages_ids |> Enum.join("\n")
    Logger.info("to #{user_id}\n#{messages}")
  end
end
