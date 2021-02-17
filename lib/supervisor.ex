defmodule Mandelbrot.Supervisor do
  use Supervisor

  def start_link(port) do
    Supervisor.start_link(__MODULE__, port, name: Mandelbrot.Supervisor)
  end

  def init(port) do
    children = [
      supervisor(Mandelbrot.Tcp.Supervisor, [port]),
      supervisor(Mandelbrot.Executor.Supervisor, [])
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

end
