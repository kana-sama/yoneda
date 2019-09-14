defmodule Yoneda.ReplicatorBot do
  @replicators Application.fetch_env!(:yoneda, :replicators)

  def request_replicator(ignore) do
    try do
      MapSet.difference(MapSet.new(@replicators), MapSet.new(ignore))
      |> Enum.random()
    rescue
      Enum.EmptyError ->
        :no_replicators
    end
  end

  def send(bot_id, message) do
    "#{bot_id} #{message}"
  end
end
