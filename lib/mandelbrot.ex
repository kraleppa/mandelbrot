defmodule Mandelbrot do
  def start(_type, arg) when is_integer(arg) do
    Mandelbrot.Supervisor.start_link(arg)
  end

  def start(_type, _args) do
    Mandelbrot.Supervisor.start_link(8080)
  end
end
