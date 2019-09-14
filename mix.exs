defmodule Yoneda.MixProject do
  use Mix.Project

  def project do
    [
      app: :yoneda,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Yoneda.Application, []}
    ]
  end

  defp deps do
    []
  end
end
