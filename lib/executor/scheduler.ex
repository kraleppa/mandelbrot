defmodule Mandelbrot.Executor.Scheduler do
  alias Mandelbrot.Util.Chunker
  alias Mandelbrot.Executor
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:start_task, settings, socket}, state) do
    run_tasks(split_points(settings), socket)
    {:noreply, state}
  end

  defp run_tasks([], _) do
    :ok
  end

  defp run_tasks([head | tail], socket) do
    Task.Supervisor.start_child(Executor.TaskSupervisor,
      fn -> Executor.MandelbrotTask.execute_task(head, socket) end)
    run_tasks(tail, socket)
  end

  defp split_points({width, height, number_of_processes}) do
    (for x <- 1..width-1, y <- 1..height-1, do: {x, y})
      |> Chunker.chunk(number_of_processes)
  end

  def start_task(settings, socket) do
    GenServer.cast(__MODULE__, {:start_task, settings, socket})
  end
end
