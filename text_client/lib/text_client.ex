defmodule TextClient do
  @spec start() :: :ok
  def start do
    TextClient.Runtime.RemoteHangman.connect()
    |> Impl.Player.start()
  end
end
