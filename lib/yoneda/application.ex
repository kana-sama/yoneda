defmodule Yoneda.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: Yoneda.Dialogue.Registry}
    ]

    opts = [
      strategy: :one_for_one,
      name: Yoneda.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end
end
