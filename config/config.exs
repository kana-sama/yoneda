import Config

config :yoneda,
  replicatory: "<id of chat as number or @name>",
  client: "<client bot token>",
  replicators:
    MapSet.new([
      "<replicator bot token 1>",
      "<replicator bot token 2>",
      "<replicator bot token 3>",
      "<replicator bot token 4>"
    ])
