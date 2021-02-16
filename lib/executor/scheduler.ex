defmodule Executor.Scheduler do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: Executor.Scheduler)
  end

  def init(_) do
    {:ok, nil}
  end

  # zmienic na casta i przetwarzac asynchronicznie!
  def handle_call({:start_task, width, height}, _from, state) do
    # uruchom taski poczekaj na nie i zwróc w odpowiedzi
    :timer.sleep(2000)
    results = width + height
    {:reply, results, state}
  end

  def start_task(width, height) do
    GenServer.call(Executor.Scheduler, {:start_task, width, height})
  end


end
