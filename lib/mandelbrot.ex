defmodule Mandelbrot do
  def start(_type, _args) do
    Executor.Supervisor.start_link()
  end
end
