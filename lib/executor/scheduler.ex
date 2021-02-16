defmodule Executor.Scheduler do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:start_task, width, height, number_of_processes}, state) do
    points = (for x <- 1..width-1, y <- 1..height-1, do: {x, y})
      |> Util.Chunker.chunk(number_of_processes)
    run_tasks(points)
    {:noreply, state}
  end

  defp run_tasks([]) do
    :ok
  end

  defp run_tasks([head | tail]) do
    Task.Supervisor.start_child(Executor.TaskSupervisor, fn -> Executor.MandelbrotTask.execute_task(head) end)
    run_tasks(tail)
  end

  def start_task(width, height, number_of_processes) do
    GenServer.cast(__MODULE__, {:start_task, width, height, number_of_processes})
  end
end
