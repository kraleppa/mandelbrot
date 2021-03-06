defmodule Mandelbrot.Executor.Supervisor do
  alias Mandelbrot.Executor
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [
      {Task.Supervisor, name: Executor.TaskSupervisor},
      {Executor.Scheduler, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

end
