defmodule Mandelbrot.Tcp.TcpConnector do
  use GenServer
  require Logger
  alias Mandelbrot.Tcp.Json.Settings

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

  def handle_info({:tcp, socket, data}, listenSocket) do
    Logger.info "Received #{data}"
    try do
      settings = Poison.decode!(data, as: %Settings{})
      Mandelbrot.Executor.Scheduler.start_task(settings, socket)
    rescue
      Poison.ParseError -> Logger.error("Wrong JSON format")
    end

    {:noreply, listenSocket}
  end


  def handle_info({:tcp_closed, _}, state), do: {:stop, :normal, state}
  def handle_info({:tcp_error, _}, state), do: {:stop, :normal, state}
end
