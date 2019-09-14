defmodule Yoneda.Application do
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

    Yoneda.test()
  end
end
