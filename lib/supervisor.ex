defmodule Mandelbrot.Supervisor do
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: Mandelbrot.Supervisor)
  end

  def init(_) do
    children = [
      supervisor(Mandelbrot.Executor.Supervisor, [])
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

end
