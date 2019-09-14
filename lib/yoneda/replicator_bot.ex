defmodule Yoneda.ReplicatorBot do
  def request_replicator(ignore) do
    ignore = MapSet.new(ignore)
    replicators = Application.fetch_env!(:yoneda, :replicators)

    try do
      Enum.random(MapSet.difference(replicators, ignore))
    rescue
      Enum.EmptyError -> :no_replicators
    end
  end

  def send(bot_id, message) do
    "#{bot_id} #{message}"
  end
end
