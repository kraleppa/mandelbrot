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
    run_tasks(split_points(settings), settings, socket)
    {:noreply, state}
  end

  defp run_tasks([], _, _) do
    :ok
  end

  defp run_tasks([head | tail], settings, socket) do
    Task.Supervisor.start_child(Executor.TaskSupervisor,
      fn -> Executor.MandelbrotTask.execute_task(head, settings, socket) end)
    run_tasks(tail, settings, socket)
  end

  defp split_points(settings) do
    (for x <- 1..settings.width-1, y <- 1..settings.height-1, do: {x, y})
      |> Chunker.chunk(settings.number_of_processes)
  end

  def start_task(settings, socket) do
    GenServer.cast(__MODULE__, {:start_task, settings, socket})
  end
end
