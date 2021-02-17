defmodule Mandelbrot.Tcp.TcpConnector do
  use GenServer
  require Logger

  def start_link(port) do
    GenServer.start_link(__MODULE__, port, name: __MODULE__)
  end

  def init(port) do
    {:ok, listenSocket} = :gen_tcp.listen(port, [:binary, active: true])
    send(self(), :accept)
    Logger.info("Accepting connections on port #{port}")
    {:ok, listenSocket}
  end

  def handle_info(:accept, listenSocket) do
    {:ok, _socket} = :gen_tcp.accept(listenSocket)
    Logger.info "Client connected"
    {:noreply, listenSocket}
  end

  def handle_info({:tcp, _socket, data}, listenSocket) do
    Logger.info "Received #{data}"


    {:noreply, listenSocket}
  end
end