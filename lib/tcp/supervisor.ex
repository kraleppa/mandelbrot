defmodule Mandelbrot.Tcp.Supervisor do
  alias Mandelbrot.Tcp
  use Supervisor

  def start_link(port) do
    Supervisor.start_link(__MODULE__, port, name: __MODULE__)
  end

  def init(port) do
    children = [
      {Tcp.TcpConnector, port}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

end
